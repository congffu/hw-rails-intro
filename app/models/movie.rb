class Movie < ActiveRecord::Base
  def self.all_ratings
    # Movie.all.select(:rating).distinct.pluck(:rating)
    ['G','PG','PG-13','R']
    # Movie.select(:rating).distinct.inject([]) { |a, m| a.push m.rating }
  end
  
  def self.with_ratings(list)
    if list.empty?
        Movie.all
    else
        list = list.map {|rating| rating.upcase}
        Movie.where(rating: list)
    end
      
  end
end