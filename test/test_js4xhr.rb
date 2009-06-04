require 'test/test_helper'

class Rack::MockRequest
  def xhr(uri, opts={})
    get(uri, opts.merge('HTTP_X_REQUESTED_WITH' => 'XMLHttpRequest'))
  end
end

App = lambda {|env|
  body = env['HTTP_ACCEPT'] || ''
  [200, {}, [body]]
}

class Js4XhrTest < Test::Unit::TestCase

  def setup
    @client = Rack::MockRequest.new(Rack::Js4Xhr.new(App))
  end

  test "prepends js media type to Accept header on xhr request" do
    response = @client.xhr('/', 'HTTP_ACCEPT' => 'text/html')
    assert_equal 'application/javascript,text/html', response.body
  end

  test "leaves Accept header untouched when not xhr request" do
    response = @client.get('/', 'HTTP_ACCEPT' => 'text/html')
    assert_equal 'text/html', response.body
  end

  test "nil Accept header" do
    response = @client.xhr('/', 'HTTP_ACCEPT' => nil)
    assert_equal 'application/javascript', response.body
  end

  test "empty Accept header" do
    response = @client.xhr('/', 'HTTP_ACCEPT' => '')
    assert_equal 'application/javascript', response.body
  end
end
