class Brewery < ActiveRecord::Base
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true

  validate :year_cannot_be_greater_than_current

  validates :year, numericality: { greater_than_or_equal_to: 1042,
                                    only_integer: true }

  scope :active, -> { where active:true }
  scope :retired, -> { where active:[nil,false] }

  def year_cannot_be_greater_than_current
    if year > Time.now.year
      errors.add(:year, "can't be greater than current year.")
    end
  end

  def self.top(n)
    Brewery.all.sort_by{ |b| -(b.average_rating||0) }[0,n]
  end
end
