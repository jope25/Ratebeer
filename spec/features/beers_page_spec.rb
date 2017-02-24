require 'rails_helper'

describe 'Beer' do
  before :each do
    FactoryGirl.create :user
    sign_in(username:"Pekka", password:"Foobar1")
    FactoryGirl.create :brewery
    FactoryGirl.create :style
    visit new_beer_path
  end

  it "is saved with a name" do
    fill_in('Name', with: 'Beer')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.by(1)

    expect(page).to have_content "Beer was successfully created."
  end

  it "is not saved without a name" do
    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.by(0)
    expect(page).to have_content "Name can't be blank"
  end
end