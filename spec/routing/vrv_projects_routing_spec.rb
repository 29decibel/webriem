require "spec_helper"

describe VrvProjectsController do
  describe "routing" do

    it "routes to #index" do
      get("/vrv_projects").should route_to("vrv_projects#index")
    end

    it "routes to #new" do
      get("/vrv_projects/new").should route_to("vrv_projects#new")
    end

    it "routes to #show" do
      get("/vrv_projects/1").should route_to("vrv_projects#show", :id => "1")
    end

    it "routes to #edit" do
      get("/vrv_projects/1/edit").should route_to("vrv_projects#edit", :id => "1")
    end

    it "routes to #create" do
      post("/vrv_projects").should route_to("vrv_projects#create")
    end

    it "routes to #update" do
      put("/vrv_projects/1").should route_to("vrv_projects#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/vrv_projects/1").should route_to("vrv_projects#destroy", :id => "1")
    end

  end
end
