module Rack
  class Js4Xhr

    def initialize(app)
      @app = app
    end

    def call(env)
      if Rack::Request.new(env).xhr?
        env['HTTP_ACCEPT'] = (env['HTTP_ACCEPT'] || '').split(',').unshift('application/javascript').join(',')
      end
      @app.call(env)
    end
  end
end
