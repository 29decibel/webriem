require 'spec_helper'

describe ActivityController do

  describe "GET 'recent'" do
    it "returns http success" do
      get 'recent'
      response.should be_success
    end
  end

end
