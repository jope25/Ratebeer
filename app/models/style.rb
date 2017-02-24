class Style < ActiveRecord::Base
  include RatingAverage

  has_many :beers
  has_many :ratings, through: :beers

  validates :name, uniqueness: true,
            presence: true
end
