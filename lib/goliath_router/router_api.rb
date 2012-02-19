require 'http_router'
require 'goliath/api'

class RouterAPI < Goliath::API
  
  def set_event_handler!(env)
    if self.class.maps?
      response = self.class.router.recognize(env)
      if response = self.class.router.recognize(env) and response.respond_to?(:path) and response.path.route.api_class
        env.event_handler = response.path.route.api_class.new(response.path.route.api_options)
      end
    end
    env.event_handler ||= self
  end
  
  
  
  
  
  
  class << self
  
    # Returns the router maps configured for the API
    #
    # @return [Array] array contains [path, klass, block]
    def maps
      @maps ||= []
    end

    def maps?
      !maps.empty?
    end
  
    # Specify a router map to be used by the API
    #
    # @example
    #  map '/version', ApiClass
    #
    # @example
    #  map '/version_get', ApiClass do
    #    # inject GET validation middleware for this specific route
    #    use Goliath::Rack::Validation::RequestMethod, %w(GET)
    #  end
    #
    #
    # @param name [String] The URL path to map.
    #   Optional parts are supported via <tt>(.:format)</tt>, variables as <tt>:var</tt> and globs via <tt>*remaining_path</tt>.
    #   Variables can be validated by supplying a Regexp.
    # @param klass [Class] The class to retrieve the middlewares from
    # @param block The code to execute
    def map(name, *args, &block)
      opts = args.last.is_a?(Hash) ? args.pop : {}
      klass = args.first
      maps.push([name, klass, opts, block])
    end
  
    [:get, :post, :head, :put, :delete].each do |http_method|
      class_eval <<-EOT, __FILE__, __LINE__ + 1
      def #{http_method}(name, *args, &block)
        opts = args.last.is_a?(Hash) ? args.pop : {}
        klass = args.first
        opts[:conditions] ||= {}
        opts[:conditions][:request_method] = [#{http_method.to_s.upcase.inspect}]
        map(name, klass, opts, &block)
      end
      EOT
    end      
  
  
    def router
      unless @router
        @router = HttpRouter.new
        @router.default(proc{ |env|
          @router.routes.last.dest.call(env)
        })
      end
      @router
    end
    
    # Use to define the 404 routing logic. As well, define any number of other paths to also run the not_found block.
    def not_found(*other_paths, &block)
      app = ::Rack::Builder.new(&block).to_app
      router.default(app)
      other_paths.each {|path| router.add(path).to(app) }
    end  
    
    
  end  
end
