class LandmarksController < ApplicationController

  get "/landmarks" do
    @landmarks = Landmark.all
    erb :"landmarks/index"
  end

  get "/landmarks/new" do
    erb :"landmarks/new"
  end

  get "/landmarks/:id" do
    id = params[:id]
    @landmark = Landmark.find(id)
    erb :"landmarks/show"
  end

  get "/landmarks/:id/edit" do
    id = params[:id]
    @landmark = Landmark.find(id)
    erb :"landmarks/edit"
  end

  post "/landmarks" do
    landmark = Landmark.new(params["landmark"])
    landmark.save
    redirect "/landmarks/#{landmark.id}"
  end

  patch "/landmarks/:id" do
    id = params[:id]
    landmark = Landmark.find(id)
    landmark.update(params['landmark'])
    redirect "/landmarks/#{landmark.id}"
  end
end
