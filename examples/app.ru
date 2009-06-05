# run me with:
#   $rackup examples/app.ru -p 3000
#
# and visit:
#   localhost:3000
#
# then look at the console output as you refresh the page and click the xhr
# request button
#
require 'pathname'
require 'rubygems'
require 'rack'

root = Pathname(__FILE__).dirname.parent.expand_path
require root + 'lib/rack/js4xhr'

class App

  def call(env)

    body = <<-BODY
    <html><head></head><body>
      <script type="text/javascript">
        function xhr() {
          var client = new XMLHttpRequest()
          client.open('GET', '/xhr', true)
          client.setRequestHeader('X-Requested-With', 'XMLHttpRequest')
          client.send(null)
        }
      </script>

      <form onSubmit="xhr(); return false">
        <input type="submit" value="xhr request" />
      </form>
    </body></html>
    BODY

    request = Rack::Request.new(env)
    header  = env['HTTP_X_REQUESTED_WITH']
    accept  = env['HTTP_ACCEPT'].split(',').first

    puts <<-INFO

      xhr request:  #{request.xhr?} (header value: #{header.inspect})
      Content-Type: #{accept}

    INFO

    [200, {'Content-Type' => 'text/html'}, [body]]
  end
end

use Rack::Js4Xhr
run App.new
