class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @movies = Movie.all
      
      @all_ratings = Movie.all_ratings
      
      if params[:ratings]
        @rating_list = params[:rating].keys
      else
        @rating_list = @all_ratings
      end
      
      @movies = Movie.with_ratings(@rating_list)
      @rating_hash = Hash[@ratings_to_show.map {|rating| [rating, '1']}]
      
      if params[:sort_by]
        @movies = @movies.order(params[:sort_by])
        if params[:sort_by] == 'title'
          @title_header = 'hilite bg-warning'
        elsif params[:sort_by] == 'release_date'
          @release_date_header = 'hilite bg-warning'
        end
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