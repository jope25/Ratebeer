class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings

  def average_rating
    ratings.average :score

#   ratings_scores = ratings.map { |rating| rating.score}
#   ratings_scores.inject(:+).fdiv(ratings.count)
  end

  def to_s
    "#{name}, #{brewery.name}"
  end
end
