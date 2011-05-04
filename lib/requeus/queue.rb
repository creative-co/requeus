module Requeus
  class Queue
    def initialize conf
      @name = conf['name']
      @endpoint = conf['endpoint']
      @workers_count = conf['workers'].to_i
      @interval = conf['interval'].to_f
    end

    attr_reader :name,
                :endpoint

    def start_workers
      workers_queue = SizedQueue.new(@workers_count)

      @workers_count.times.map do
        Thread.new do
          loop do
            begin
              server, queue, handle, request = workers_queue.pop

              if request.do_request queue.endpoint
                server.confirm queue.name, handle
                request.delete_files
              end
            rescue Exception => e
              puts e
              puts e.backtrace.join("\n")
            end
          end
        end
      end

      Requeus::Impl.instance.server_sequence.map do |s|
        Thread.new(s) do |server|
          loop do
            begin
              requests = server.get @name, workers_queue.num_waiting

              if requests.empty?
                sleep server.interval * @interval
              else
                requests.each {|handle, request| workers_queue << [server, self, handle, Requeus::Request.from_json(request)]}
              end
            rescue Exception => e
              puts e
              puts e.backtrace.join("\n")
            end
          end
        end
      end
    end
  end
end