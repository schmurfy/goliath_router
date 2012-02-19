#!/usr/bin/env ruby
$:<< '../lib' << 'lib'

require 'goliath'
require 'yajl'

require 'goliath_router'

Goliath::Application.builder_class = RouterBuilder


class Base < Goliath::API
  use Goliath::Rack::Params
  use Goliath::Rack::Render, 'json'

  def response(env)
    [200, {}, {:p => params}]
  end
end

class Extend < Base
  def response(env)
    [200, {}, params]
  end
end

class Router < RouterAPI
  map '/base', Base
  map '/extend', Extend
end
