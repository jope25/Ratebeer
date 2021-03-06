class Beer < ActiveRecord::Base
  include RatingAverage

  belongs_to :brewery, touch: :true
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { uniq }, through: :ratings, source: :user

  validates :name, presence: true
  validates :style, presence: true
  validates :brewery, presence: true

  def to_s
    "#{name}, #{brewery.name}"
  end

  def self.top(n)
    Beer.all.sort_by{ |b| -(b.average_rating||0) }[0,n]
  end
end
