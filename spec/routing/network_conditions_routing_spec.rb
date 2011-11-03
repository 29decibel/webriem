require "spec_helper"

describe NetworkConditionsController do
  describe "routing" do

    it "routes to #index" do
      get("/network_conditions").should route_to("network_conditions#index")
    end

    it "routes to #new" do
      get("/network_conditions/new").should route_to("network_conditions#new")
    end

    it "routes to #show" do
      get("/network_conditions/1").should route_to("network_conditions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/network_conditions/1/edit").should route_to("network_conditions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/network_conditions").should route_to("network_conditions#create")
    end

    it "routes to #update" do
      put("/network_conditions/1").should route_to("network_conditions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/network_conditions/1").should route_to("network_conditions#destroy", :id => "1")
    end

  end
end
