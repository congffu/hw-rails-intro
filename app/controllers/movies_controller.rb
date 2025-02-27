class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      # session.clear
      @movies = Movie.all
      
      @all_ratings = Movie.all_ratings
      
      @rating_hash = {}
      if params[:ratings]
        @rating_hash = params[:ratings]
      elsif session[:ratings]
        @rating_hash = session[:ratings]
      else
        @rating_list = @all_ratings
        @rating_hash = Hash[@rating_list.map {|rating| [rating, "1"]}]
      end
      
      session[:ratings] = @rating_hash
      
      @movies = Movie.with_ratings(@rating_hash.keys)
      
      
      @sort = params[:sort] || session[:sort]
        
      session[:sort] = @sort
        
      # flash.keep
      # if @sort
      @movies = @movies.order(@sort)
      if @sort == 'title'
        @title_header = 'hilite bg-warning'
      elsif @sort == 'release_date'
        @release_date_header = 'hilite bg-warning'
      end
      # end
      
      if params[:sort]!=session[:sort] or params[:ratings]!=session[:ratings]
        flash.keep
        redirect_to movies_path(:sort => session[:sort], :ratings => @rating_hash)
      end
          
    end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end