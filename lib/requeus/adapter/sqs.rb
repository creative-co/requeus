module Requeus
  module Adapter
    class SQS
      def initialize options = {}
        @options = options
      end

      def put queue, request
        get_queue(queue).send_message(request)
      end

      def get queue, limit = 1
        get_queue(queue).receive_messages(limit).map do |message|
          [message.receipt_handle, message.body]
        end
      end

      def confirm queue, handle
        connection.interface.delete_message(connection.interface.queue_url_by_name(queue), handle)
      end

      private
      
      def get_queue queue
        (@queues ||= {})[queue] ||= connection.queue(queue)
      end
      
      def connection
        @connection ||= Aws::Sqs.new(@options['access_key_id'], @options['secret_access_key'])
      end

      Requeus::Server.adapters['sqs'] = self
    end
  end
end