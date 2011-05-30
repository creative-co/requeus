require 'thread'

%w(blob_store impl queue request server adapters).each do |file|
  require "requeus/#{file}"
end

require 'requeus/railtie' if defined?(Rails)

module Requeus
  class << self
    # extra_args can be
    # :headers
    #:force_endpoint
    def request queue, method, path, params = {}, extra_args = {}
      headers = extra_args[:headers] || {}
      force_endpoint = extra_args[:force_endpoint]
      Requeus::Impl.instance.request queue, method, path, params, headers, force_endpoint
    end

    def start_workers
      Requeus::Impl.instance.start_workers
    end

    def config_path= path;
      Requeus::Impl.instance.config_path = path;
    end
  end
end
