class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    params[:sort_by] = nil unless params[:sort_by] == 'title' or params[:sort_by] == 'release_date'
    @highlight = params[:sort_by]
    @all_ratings = Movie.ratings
    @ratings = params[:ratings].keys unless params[:ratings].nil?
    unless @ratings.nil?
      @movies = Movie.find(:all, :order => params[:sort_by], :conditions => {:rating => @ratings})
    else
      @movies = Movie.find(:all, :order => params[:sort_by])
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
