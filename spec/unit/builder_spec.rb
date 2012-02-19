# encoding: utf-8
require 'spec_helper'

describe Goliath::Rack::Builder do

  SimpleMiddleware = Class.new
  NestedMiddleware = Class.new

  class NestedClassApi < Goliath::API
    use NestedMiddleware, 'class'
  end

  class NestedBlockApi < Goliath::API
    use NestedMiddleware, 'block'
  end

  class SimpleRouter < RouterAPI
    use SimpleMiddleware
    map "/class", NestedClassApi
    map "/block" do
      run NestedBlockApi.new
    end
  end

  let(:router) { SimpleRouter.new }

  describe '.build' do

    it "builds rack app for api" do
      Rack::Builder.should_receive(:app)
      Goliath::Rack::Builder.build(router.class, router)
    end

    it "loads rack/goliath middlewares" do
      SimpleMiddleware.should_receive(:new)
      Goliath::Rack::Builder.build(router.class, router)
    end

  end
end
