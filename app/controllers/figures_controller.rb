class FiguresController < ApplicationController

  get '/figures' do
    @figures = Figure.all
    erb :'figures/index'
  end

  get '/figures/new' do
    @titles = Title.all
    @landmarks = Landmark.all
    erb :'figures/new'
  end

  post '/figures' do
    @figure = Figure.create(name: params["figure"]["name"])

    if !(params["figure"]["title_ids"] == nil)
      @title_array = params["figure"]["title_ids"]
    else
      @title_array = []
    end

    if !params["title"]["name"].empty?
      @new_title = Title.create(name: params["title"]["name"])
      @title_array << @new_title.id
    end

    @title_array.each do |title_id|
      FigureTitle.create(figure_id: @figure.id, title_id: title_id)
    end

    @landmark_array = params["figure"]["landmark_ids"]
    if !(@landmark_array == nil)
      @landmark_array.each do |landmark_id|
        @landmark = Landmark.find(landmark_id)
        @landmark.update(figure_id: @figure.id)
      end
    end

    @new_landmark_name = params["landmark"]["name"]
    @new_landmark_year = params["landmark"]["year_completed"]
    if !(@new_landmark_name.empty?)
      @new_landmark = Landmark.create(name: @new_landmark_name, year_completed: @new_landmark_year, figure_id: @figure.id)
    end

    redirect "/figures/#{@figure.id}"
  end

  get '/figures/:id' do
    @figure = Figure.find(params[:id])
    erb :'figures/show'
  end

  get '/figures/:id/edit' do
    @titles = Title.all
    @landmarks = Landmark.all
    @figure = Figure.find(params[:id])
    erb :'figures/edit'
  end

  patch '/figures/:id' do
    @figure = Figure.find(params[:id])
    @figuretitles = FigureTitle.all
    @title_array = params["figure"]["title_ids"]
    @landmark_array = params["figure"]["landmark_ids"]

  #############Delete all titles and add new ones###############
    @zz = @figuretitles.select do |ft|
      ft.figure_id == @figure.id
    end

    @zz.each do |ft|
      FigureTitle.delete(ft.id)
    end

    if params["figure"]["title_ids"] == nil
      @title_array = []
    end

    if !params["title"]["name"].empty?
      @new_title = Title.create(name: params["title"]["name"])
      @title_array << @new_title.id
    end

    @title_array.each do |title_id|
      FigureTitle.create(figure_id: @figure.id, title_id: title_id)
    end

#############Delete all landmarks and add new ones###############

    @yy = Landmark.select do |el|
      el.figure_id == @figure.id
    end

    @yy.each do |el|
      el.update(figure_id: "NULL")
    end

    @new_landmark_name = params["landmark"]["name"]
    @new_landmark_year = params["landmark"]["year_completed"]
    if !(@new_landmark_name.empty?)
      @new_landmark = Landmark.create(name: @new_landmark_name, year_completed: @new_landmark_year, figure_id: @figure.id)
    end

    if !(@landmark_array == nil)
      @landmark_array.each do |landmark_id|
        @landmark = Landmark.find(landmark_id)
        @landmark.update(figure_id: @figure.id)
      end
    end

#############Update the figure name###############

    @figure.update(name: params["figure"]["name"])
    @figure.save

    redirect "/figures/#{@figure.id}"
  end

end
