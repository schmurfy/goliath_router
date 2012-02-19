require 'spec_helper'
require 'goliath/api'

describe Goliath::API do

  DummyApi = Class.new(RouterAPI)

  describe ".maps?" do
    context "when not using maps" do
      it "returns false" do
        DummyApi.maps?.should be_false
      end
    end
  
    context "when using maps" do
      it "returns true" do
        DummyApi.map "/foo"
        DummyApi.maps?.should be_true
      end
    end
  end

end
