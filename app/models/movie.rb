class Movie < ActiveRecord::Base
  def self.ratings
    ratings = []
    Movie.find(:all, :select => 'rating',  :group => 'rating').each { |m| ratings = ratings + [m.rating] }
    ratings
  end
end
