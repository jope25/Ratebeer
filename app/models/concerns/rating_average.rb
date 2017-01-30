module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    ratings.average :score

#   ratings_scores = ratings.map { |rating| rating.score}
#   ratings_scores.inject(:+).fdiv(ratings.count)
  end
end