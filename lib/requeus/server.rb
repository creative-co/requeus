module Requeus
  class Server

    private

    def self.forward_to method_name, obj
      class_eval <<-EOS
        def #{method_name}(*args, &block)
          #{obj}.send(#{method_name.inspect}, *args, &block)
        end
      EOS
    end

    public

    forward_to :put, :connection
    forward_to :get, :connection
    forward_to :confirm, :connection

    def initialize name, conf
      @name = name
      @connection = self.class.adapters[conf['adapter']].new(conf)
      @interval = conf['interval'].to_f
    end
    
#    delegate :put, :get, :confirm,
#             :to => :connection

    attr_reader :name,
                :interval
    
    private
    
    attr_reader :connection
    
    def self.adapters
      @@adapters ||= {}
    end
  end
end