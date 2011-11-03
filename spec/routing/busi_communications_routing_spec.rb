require "spec_helper"

describe BusiCommunicationsController do
  describe "routing" do

    it "routes to #index" do
      get("/busi_communications").should route_to("busi_communications#index")
    end

    it "routes to #new" do
      get("/busi_communications/new").should route_to("busi_communications#new")
    end

    it "routes to #show" do
      get("/busi_communications/1").should route_to("busi_communications#show", :id => "1")
    end

    it "routes to #edit" do
      get("/busi_communications/1/edit").should route_to("busi_communications#edit", :id => "1")
    end

    it "routes to #create" do
      post("/busi_communications").should route_to("busi_communications#create")
    end

    it "routes to #update" do
      put("/busi_communications/1").should route_to("busi_communications#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/busi_communications/1").should route_to("busi_communications#destroy", :id => "1")
    end

  end
end
