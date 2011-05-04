module Requeus
  class BlobStore
    def initialize name, conf
      @name = name
      @connection = self.class.adapters[conf['adapter']].new(conf)
    end
    
    delegate :put, :get, :delete,
             :to => :connection

    attr_reader :name
    
    private
    
    attr_reader :connection
    
    def self.adapters
      @@adapters ||= {}
    end
  end
end