class HttpRouter::Route
  attr_accessor :api_class, :api_options
end


class RouterBuilder < Goliath::Rack::Builder
  
  def self.build(klass, api)
    app do
      klass.middlewares.each do |mw_klass, args, blk|
        use(mw_klass, *args, &blk)
      end
      
      if klass.respond_to?(:maps?) && klass.maps?
        klass.maps.each do |path, route_klass, opts, blk|
          route = klass.router.add(path, opts.dup)
          route.api_options = opts.delete(:api_options) || {}
          route.api_class = route_klass

          route.to do |env|
            builder = RouterBuilder.new
            env['params'] ||= {}
            env['params'].merge!(env['router.params']) if env['router.params']

            builder.params = builder.retrieve_params(env)
            builder.instance_eval(&blk) if blk

            if route_klass
              route_klass.middlewares.each do |mw|
                builder.instance_eval { use mw[0], *mw[1], &mw[2] }
              end
            end

            if route_klass or blk.nil?
              builder.instance_eval { original_run env.event_handler }
            end

            builder.to_app.call(env)
          end
        end  
        
        original_run klass.router
      else
        original_run api
      end  
      
    end
  end
  
end
