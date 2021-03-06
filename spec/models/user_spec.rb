require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is saved with a proper password" do
    user = User.create username:"Pekka", password:"Secret1", password_confirmation:"Secret1"

    expect(user).to be_valid
    expect(User.count).to eq(1)
  end

  it "is not saved with a too short password" do
    user = User.create username:"Pekka", password:"Aa1", password_confirmation:"Aa1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with a password containing only letters" do
    user = User.create username:"Pekka", password:"abcde", password_confirmation:"abcde"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      FactoryGirl.create(:rating, beer: beer, user: user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      brewery = FactoryGirl.create(:brewery)
      style = FactoryGirl.create(:style)
      best = create_beer_with_rating(brewery, style, user, 25)
      create_beers_with_ratings(brewery, style, user, 10, 20, 15, 7, 9)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryGirl.create(:user) }
    let(:brewery){ FactoryGirl.create(:brewery) }
    let(:style){ FactoryGirl.create(:style) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the brewery of only rated if only one rating" do
      beer = create_beer_with_rating(brewery, style, user, 25)

      expect(user.favorite_brewery).to eq(brewery)
    end

    it "is the brewery with best average if many ratings" do
      best = FactoryGirl.create(:brewery)
      create_beers_with_ratings(brewery, style, user, 10, 7, 9)
      create_beers_with_ratings(best, style, user, 35, 45)
      create_beers_with_ratings(FactoryGirl.create(:brewery), style, user, 50, 10, 15, 20)

      expect(user.favorite_brewery).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryGirl.create(:user) }
    let(:brewery){ FactoryGirl.create(:brewery) }
    let(:style){ FactoryGirl.create(:style) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the style of only rated if only one rating" do
      create_beer_with_rating(brewery, style, user, 25)

      expect(user.favorite_style).to eq(style)
    end

    it "is the style with best average if many ratings" do
      best = FactoryGirl.create(:style, name:"best")
      create_beers_with_ratings(brewery, style, user, 10, 7, 9)
      create_beers_with_ratings(brewery, best, user, 35, 45)
      create_beers_with_ratings(brewery, FactoryGirl.create(:style, name:"Lager"), user, 50, 10, 15, 20)

      expect(user.favorite_style).to eq(best)
    end
  end
end