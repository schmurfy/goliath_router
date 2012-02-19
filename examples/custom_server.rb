#!/usr/bin/env ruby
$:<< '../lib' << 'lib'

require 'goliath/api'
require 'goliath/runner'
require 'goliath/application'
require 'goliath_router'

Goliath::Application.builder_class = RouterBuilder

# Example demonstrating how to use a custom Goliath runner
#

class Hello < Goliath::API
  def response(env)
    [200, {}, "hello!"]
  end
end

class Bonjour < Goliath::API
  def response(env)
    [200, {}, "bonjour!"]
  end
end

class Custom < RouterAPI
  map "/hello", Hello
  map "/bonjour", Bonjour
end

runner = Goliath::Runner.new(ARGV, nil)
runner.api = Custom.new
runner.app = Goliath::Application.builder_class.build(Custom, runner.api)
runner.run