require "pry"
class FiguresController < ApplicationController
  # add controller methods

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
    @figure = Figure.create(params[:figure])
    if !params[:title][:name].empty?
      @new_title = Title.create(params[:title])
      @figure.titles << @new_title
    end

    if !params[:landmark][:name].empty?
      @new_landmark = Landmark.create(params[:landmark])
      @figure.landmarks << @new_landmark
    end

    redirect to "/figures/#{@figure.id}"
  end

  get '/figures/:id' do
    @figure = Figure.find(params[:id])
    erb :'figures/show'
  end

  patch '/figures/:id' do
    @figure = Figure.find(params[:id])
    @figure.update(params[:figure])
    if !params[:title][:name].empty?
      @new_title = Title.create(params[:title])
      @figure.titles << @new_title
    end

    if !params[:landmark][:name].empty?
      @new_landmark = Landmark.create(params[:landmark])
      @figure.landmarks << @new_landmark
    end

    @figure.save

    redirect to "/figures/#{@figure.id}"
  end

  get '/figures/:id/edit' do
    @figure = Figure.find(params[:id])
    @titles = Title.all
    @landmarks = Landmark.all

    erb :'figures/edit'
  end

end
