

class FiguresController < ApplicationController

  ## read
  get '/figures' do
    @figures = Figure.all
    erb :'figures/index'
  end


  ## start new
  get '/figures/new' do
    @titles = Title.all
    @landmarks = Landmark.all
    erb :'figures/new'
  end

  ## finish new
  post '/figures' do
    figure = Figure.new(name: params[:figure][:name])
    figure.save
    if params[:figure].keys.include?("landmark_ids")
      landmark_array = params[:figure][:landmark_ids].collect {|id|
        Landmark.find(id.to_i)
      }
      landmark_array.each {|landmark|
        figure.landmarks << landmark
      }
    end
    if params[:figure].keys.include?("title_ids")
      title_array = params[:figure][:title_ids].collect {|id|
        Title.find(id.to_i)
      }
      title_array.each {|title|
        figure.titles << title
      }
    end

    if !params[:landmark][:name].empty?
      new_landmark = Landmark.create(name: params[:landmark][:name], year_completed: params[:landmark][:year_completed].to_i)
      figure.landmarks << new_landmark
    end

    if !params[:title][:name].empty?
      new_title = Title.create(name: params[:title][:name])
      figure.titles << new_title
    end

    redirect "/figures/#{figure.id}"
  end

  ## single figure
  get '/figures/:id' do
    @figure = Figure.find(params[:id])

    erb :'figures/show'
  end

  ## start edit
  get '/figures/:id/edit' do
    @figure = Figure.find(params[:id])
    @titles = Title.all
    @landmarks = Landmark.all
    erb :'figures/edit'
  end

  ## end edit
  patch '/figures/:id' do
    # binding.pry
    figure = Figure.find(params[:id])
    figure.name = (params[:figure][:name])

    new_titles = []
    new_landmarks = []

    if params[:figure].keys.include?("landmark_ids")
      landmark_array = params[:figure][:landmark_ids].collect {|id|
        Landmark.find(id.to_i)
      }
      landmark_array.each {|landmark|
        new_landmarks << landmark
      }
    end
    if params[:figure].keys.include?("title_ids")
      title_array = params[:figure][:title_ids].collect {|id|
        Title.find(id.to_i)
      }
      title_array.each {|title|
        new_titles << title
      }
    end

    if !params[:landmark][:name].empty?
      new_landmark = Landmark.create(name: params[:landmark][:name], year_completed: params[:landmark][:year_completed].to_i)
      new_landmarks << new_landmark
    end

    if !params[:title][:name].empty?
      new_title = Title.create(name: params[:title][:name])
      new_titles << new_title
    end

    figure.landmarks = new_landmarks
    figure.titles = new_titles

    figure.save

    redirect "figures/#{figure.id}"
  end

end
