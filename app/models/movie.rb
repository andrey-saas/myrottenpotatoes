class Movie < ActiveRecord::Base

  def released_1930_or_later  
    errors.add(:release_date, "must be 1930 or later") if self.release_date < Date.parse("1 Jan 1930") 
  end 

  def grandfathered?
    self.release_date >= Date.parse("1 Nov 1967")
  end

  def self.find_with_same_director(movie)
    where("id <> :id AND director = :director", {:id => movie.id, :director => movie.director})
  end

  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  validates :title, :presence => true
  validates :release_date, :presence => true
  validates :rating, :inclusion => {:in => self.all_ratings}, :unless => :grandfathered?

  validate :released_1930_or_later
  
end

