class User < ActiveRecord::Base
  include RatingAverage

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  validates :username, uniqueness: true,
            length: { minimum: 3,
                      maximum: 30 }

  validates :password, format: { with: /\A(?=.*[A-Z])(?=.*\d).{4,}\z/,
                                    message: "must be atleast 4 characters long and include one big letter and one number." }

  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_brewery
    favorite(:brewery)
  end

  def favorite_style
    favorite(:style)
  end

  def favorite(which)
    return nil if ratings.empty?

    ratings_of_items = ratings.group_by { |r| r.beer.send(which) }
    averages_of_items = []
    ratings_of_items.each do |item, ratings|
      averages_of_items << {
          item: item,
          rating: ratings.map(&:score).sum / ratings.count.to_f
      }
    end
    averages_of_items.sort_by{ |b| -b[:rating] }.first[:item]
  end

  def is_member_of?(beer_club)
    beer_clubs.include? beer_club
  end

  def self.most_active(n)
    User.all.sort_by{ |b| -(b.ratings.count||0) }[0,n]
  end
end