require 'thread'

%w(blob_store impl queue request server adapters).each do |file|
  require "requeus/#{file}"
end

require 'requeus/railtie' if defined?(Rails)

module Requeus
  class << self
    def request queue, method, path, params = {}, headers = {}
      Requeus::Impl.instance.request queue, method, path, params, headers
    end

    def start_workers
      Requeus::Impl.instance.start_workers
    end

    def config_path= path;
      Requeus::Impl.instance.config_path = path;
    end
  end
end
