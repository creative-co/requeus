require 'singleton'

module Requeus
  class Impl
    include Singleton

    def request queue, method, path, params, headers, force_endpoint
      r = Requeus::Request.new(method, path, params, headers, force_endpoint).to_json
      server_sequence.any? {|q| q.put(queues[queue].name, r)}
    end

    def start_workers
      queues.values.map {|q| q.start_workers}.flatten.each(&:join)
    end
    
    def config_path= path
      @config_path = path
    end

    def config
      @config ||= YAML.load_file(@config_path)[ENV['REQUEUS_ENV'] || ENV['RAILS_ENV'] || 'development']
    end

    def queues
      @queues ||= {}.tap do |queues|
        config['queues'].each do |name, conf|
          queues[name] = Requeus::Queue.new conf
        end
      end
    end

    def server_sequence
      @server_sequence ||= config['servers']['sequence'].split.map do |name|
        conf = @config['servers'][name]
        Requeus::Server.new name, conf
      end
    end

    def blob_sequence
      @blob_sequence ||= config['blob']['sequence'].split.map do |name|
        conf = @config['blob'][name]
        Requeus::BlobStore.new name, conf
      end
    end
  end
end