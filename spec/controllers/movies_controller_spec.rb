require 'spec_helper'

describe MoviesController do

  describe 'movie operations' do
  
    before :each do
      @fake_movie = mock(Movie)
      @fake_movie.stub(:title)
    end  
    
    describe 'creating movie' do
      before :each do
        @params = {:movie => {'title' => 'new title', 'description' => 'new description', 'rating' => 'rating'}}
      end        
      it 'should call the model method that creates new movie' do
        Movie.should_receive(:create!).with(@params[:movie]).and_return(@fake_movie)
        post :create, @params
      end  
      it 'should redirect to index template' do
        post :create, @params      
        response.should redirect_to(movies_path)
      end  
    end    
    
    describe 'call model method to find movie' do
      before :each do
        @params = {:id => 'movie_id'}
        Movie.should_receive(:find).with(@params[:id]).and_return(@fake_movie)
      end        
      
      describe 'delete movie info' do
        it 'should call model method to delete movie info' do
          @fake_movie.should_receive(:destroy)
          post :destroy, @params
        end  
        describe 'after model call' do
          before :each do
            @fake_movie.stub(:destroy)        
            post :destroy, @params               
          end
          it 'should make movie available to code' do
            assigns(:movie).should == @fake_movie          
          end  
          it 'should redirect to index page' do
            response.should redirect_to(movies_path)
          end  
        end  
      end
    end
    
  end  

  describe 'searching movies with same director' do
  
    ORIGIN_MOVIE_ID = -1
    ORIGIN_MOVIE_TITLE = 'TITLE'
    ORIGIN_MOVIE_DIRECTOR = 'DIRECTOR'  
  
    before :each do
      @origin_movie = mock(Movie)
      @origin_movie.stub(:id).and_return(ORIGIN_MOVIE_ID)
      @origin_movie.stub(:title).and_return(ORIGIN_MOVIE_TITLE)
      @origin_movie.stub(:director).and_return(ORIGIN_MOVIE_DIRECTOR)
            
      @similar_movies = [mock(Movie), mock(Movie)]
      @similar_movies.each do |movie|
        movie.stub(:director).and_return(ORIGIN_MOVIE_DIRECTOR)
      end
      
      @not_found_movies = []   
    end
    
    it 'should call model method to find movies by director' do
      Movie.stub(:find).with(@origin_movie.id.to_s).and_return(@origin_movie)  
      Movie.should_receive(:find_with_same_director).with(@origin_movie).and_return(@similar_movies)
      post :show_with_same_director, {:id => @origin_movie.id}
    end
    
    describe 'after successfull search' do
      before :each do
        Movie.stub(:find).with(@origin_movie.id.to_s).and_return(@origin_movie)  
        Movie.stub(:find_with_same_director).with(@origin_movie).and_return(@similar_movies)
        post :show_with_same_director, {:id => @origin_movie.id}       
      end
      
      it 'should select proper view for rendering' do
        response.should render_template('show_with_same_director')
      end
      
      it 'should make movies accessible to template' do
        assigns(:movies).should == @similar_movies
      end
      
      it 'should make origin movie available to template' do
        assigns(:origin_movie).should == @origin_movie
      end  
    end  
    
    describe 'after unsuccessful search' do
      before :each do
        Movie.stub(:find).with(@origin_movie.id.to_s).and_return(@origin_movie)  
        Movie.stub(:find_with_same_director).with(@origin_movie).and_return(@not_found_movies)
        post :show_with_same_director, {:id => @origin_movie.id}             
      end
      
      it 'should select proper view for rendering' do
        response.should redirect_to(movies_path)
      end
      
      it 'should display warning that movie has no director info' do
        flash[:warning].should == "'#{@origin_movie.title}' has no director info"
      end
    end    
  end

end
