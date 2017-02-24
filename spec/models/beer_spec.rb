require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "is saved with a proper name and style and brewery are set" do
    beer = Beer.create name:"Karhu", brewery: FactoryGirl.create(:brewery), style: FactoryGirl.create(:style)

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "is not saved without a name" do
    beer = Beer.create brewery: FactoryGirl.create(:brewery), style: FactoryGirl.create(:style)

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a style" do
    beer = Beer.create name:"Karhu", brewery: FactoryGirl.create(:brewery)

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "is not saved without a brewery" do
    beer = Beer.create name:"Karhu", style: FactoryGirl.create(:style)

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end