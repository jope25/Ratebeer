require 'rails_helper'

include Helpers

describe "User" do
  let!(:user) { FactoryGirl.create :user }

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and password do not match'
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')

    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  describe "when has given ratings" do
    let!(:brewery) { FactoryGirl.create :brewery }
    let!(:style) { FactoryGirl.create :style }

    before :each do
      create_beers_with_ratings(brewery, style, user, 10, 20)
    end

    it "they are listed at user's page" do
      visit user_path(user.id)
      expect(page).to have_content "anonymous 10"
      expect(page).to have_content "anonymous 20"
    end

    it "only user's own ratings are listed" do
      user2 = FactoryGirl.create(:user, username:"Pouta")
      create_beer_with_rating(brewery, style, user2, 15)
      visit user_path(user.id)
      expect(page).to have_no_content "anonymous 15"
    end

    it "when logged in, can delete own ratings" do
      sign_in(username:"Pekka", password:"Foobar1")
      visit user_path(user.id)
      expect{
        page.all('a', :text => 'delete')[1].click
      }.to change{Rating.count}.by(-1)
    end

    describe "user's page shows" do
      before :each do
        brewery2 = FactoryGirl.create(:brewery, name: "test")
        style2 = FactoryGirl.create(:style, name: "Lager")
        create_beers_with_ratings(brewery2, style2, user, 30, 40)
        visit user_path(user.id)
      end

      it "favorite brewery" do
        expect(page).to have_content "Favorite brewery: test"
      end

      it "favorite style" do
        expect(page).to have_content "Favorite style: Lager"
      end
    end
  end
end