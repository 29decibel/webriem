require "spec_helper"

describe ProductTestsController do
  describe "routing" do

    it "routes to #index" do
      get("/product_tests").should route_to("product_tests#index")
    end

    it "routes to #new" do
      get("/product_tests/new").should route_to("product_tests#new")
    end

    it "routes to #show" do
      get("/product_tests/1").should route_to("product_tests#show", :id => "1")
    end

    it "routes to #edit" do
      get("/product_tests/1/edit").should route_to("product_tests#edit", :id => "1")
    end

    it "routes to #create" do
      post("/product_tests").should route_to("product_tests#create")
    end

    it "routes to #update" do
      put("/product_tests/1").should route_to("product_tests#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/product_tests/1").should route_to("product_tests#destroy", :id => "1")
    end

  end
end
