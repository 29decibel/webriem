require "spec_helper"

describe TechCommunicationsController do
  describe "routing" do

    it "routes to #index" do
      get("/tech_communications").should route_to("tech_communications#index")
    end

    it "routes to #new" do
      get("/tech_communications/new").should route_to("tech_communications#new")
    end

    it "routes to #show" do
      get("/tech_communications/1").should route_to("tech_communications#show", :id => "1")
    end

    it "routes to #edit" do
      get("/tech_communications/1/edit").should route_to("tech_communications#edit", :id => "1")
    end

    it "routes to #create" do
      post("/tech_communications").should route_to("tech_communications#create")
    end

    it "routes to #update" do
      put("/tech_communications/1").should route_to("tech_communications#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/tech_communications/1").should route_to("tech_communications#destroy", :id => "1")
    end

  end
end
