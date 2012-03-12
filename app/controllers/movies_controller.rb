class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #Compare params in params and session hashes. If filling is needed, redirect_to with correct set.
    debugger
    params[:sort_by] = nil unless params[:sort_by] == 'title' or params[:sort_by] == 'release_date'
    @all_ratings = Movie.ratings
    @ratings = []
    if not params[:sort_by].nil?
      session[:sort_by] = params[:sort_by]
    elsif not session[:sort_by].nil?
      params[:sort_by] = session[:sort_by]
      redirect_to movies_path params
    end
    if params[:commit] == 'Refresh'
      session.delete(:ratings)
    end
    if not params[:ratings].nil?
      session[:ratings] = params[:ratings] 
      @ratings = session[:ratings].keys
    elsif not session[:ratings].nil?
      params[:ratings] = session[:ratings]
      redirect_to movies_path params
    end
    
    unless @ratings.empty?
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
