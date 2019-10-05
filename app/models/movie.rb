class Movie < ActiveRecord::Base
    # Where clause      : https://guides.rubyonrails.org/active_record_querying.html#conditions
    # Case insensitivity: https://stackoverflow.com/questions/2220423/case-insensitive-search-in-rails-model
    def self.with_ratings(vals)
        Movie.where(rating: vals)
    end
end
