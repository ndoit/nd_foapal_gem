require "rails_helper"

RSpec.describe ParentRecordsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/parent_records").to route_to("parent_records#index")
    end

    it "routes to #new" do
      expect(:get => "/parent_records/new").to route_to("parent_records#new")
    end

    it "routes to #show" do
      expect(:get => "/parent_records/1").to route_to("parent_records#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/parent_records/1/edit").to route_to("parent_records#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/parent_records").to route_to("parent_records#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/parent_records/1").to route_to("parent_records#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/parent_records/1").to route_to("parent_records#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/parent_records/1").to route_to("parent_records#destroy", :id => "1")
    end

  end
end
