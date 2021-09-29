class Movie < ActiveRecord::Base
    def self.all_ratings
        self.all.select(:rating).distinct.pluck(:rating)
    end
    
    def self.with_ratings(list)
        if list.empty?
            Movie.all
        else
            Movie.where(rating: list)
        end
        
    end
end