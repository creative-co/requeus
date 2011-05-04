require 'carrot'

#todo: schedule 'recover' action to mimic SQS behaviour

module Requeus
  module Adapter
    class Rabbit
      def initialize opts
        @opts = opts
      end

      def put queue, request
        cmd cq(queue), :publish, request, :persistent => true
        true
      end

      def get queue, limit = 1
        result = []
        requests = 0

        while requests <= limit && r = pop_request(cq(queue))
          result << r
          requests += 1
        end

        result
      end
      
      def confirm queue, handle
        cq(queue).delivery_tag = handle
        cmd cq(queue), :ack
        true
      end

      private

      def cq name
        client.queue(name, :durable => true)
      end

      def pop_request queue
        request = cmd queue, :pop
        [queue.delivery_tag, request] if request
      end

      def cmd queue, command, *args
        retried = false
        begin
          queue.send(command, *args)
        rescue Carrot::AMQP::Server::ServerDown => e
          puts 'Reconnecting...'
          unless retried
            drop_client
            retried = true
            retry
          else
            raise e
          end
        end
      end

      def drop_client
        Thread.current[:requeus_rabbit_client] = nil
      end

      def client
        Thread.current[:requeus_rabbit_client] ||= Carrot.new(
            :host => @opts['host'],
            :port => @opts['port'].to_i,
            :user => @opts['user'],
            :pass => @opts['pass'],
            :vhost => @opts['vhost']
        )
      end

      Requeus::Server.adapters['rabbit'] = self
    end
  end
end
