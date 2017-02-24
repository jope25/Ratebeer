require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery }
  let!(:style) { FactoryGirl.create :style }
  let!(:beer1) { FactoryGirl.create :beer, name:"Iso 3", brewery:brewery, style:style }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery, style:style }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select(beer1.name, from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  describe "when several exist" do
    before :each do
      create_rating(beer1.name, 1)
      create_rating(beer2.name, 50)
      visit ratings_path
    end

    it "they are shown at ratings page" do
      expect(page).to have_content "#{beer1.name} 1 #{user.username}"
      expect(page).to have_content "#{beer2.name} 50 #{user.username}"
    end

    it "their total number is shown at ratings page" do
      expect(page).to have_content "Total of #{Rating.count} ratings given"
    end
  end
end

def create_rating(beer_name, score)
    visit new_rating_path
    select(beer_name, from:'rating[beer_id]')
    fill_in('rating[score]', with:score)
    click_button "Create Rating"
end