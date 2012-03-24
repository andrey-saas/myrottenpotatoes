class Movie < ActiveRecord::Base

  def self.find_with_same_director(movie)
    where("id <> :id AND director = :director", {:id => movie.id, :director => movie.director})
  end

  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
end
