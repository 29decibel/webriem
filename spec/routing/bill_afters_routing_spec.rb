require "spec_helper"

describe BillAftersController do
  describe "routing" do

    it "routes to #index" do
      get("/bill_afters").should route_to("bill_afters#index")
    end

    it "routes to #new" do
      get("/bill_afters/new").should route_to("bill_afters#new")
    end

    it "routes to #show" do
      get("/bill_afters/1").should route_to("bill_afters#show", :id => "1")
    end

    it "routes to #edit" do
      get("/bill_afters/1/edit").should route_to("bill_afters#edit", :id => "1")
    end

    it "routes to #create" do
      post("/bill_afters").should route_to("bill_afters#create")
    end

    it "routes to #update" do
      put("/bill_afters/1").should route_to("bill_afters#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/bill_afters/1").should route_to("bill_afters#destroy", :id => "1")
    end

  end
end
