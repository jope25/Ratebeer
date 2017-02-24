require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
        [ Place.new( name:"Oljenkorsi", id: 1 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if several are returned by the API, all are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("helsinki").and_return(
        [ Place.new( name:"Oljenkorsi", id: 1 ), Place.new( name:"Black Bird", id: 2 ), Place.new( name:"Oluthuone", id: 3 ) ]
    )

    visit places_path
    fill_in('city', with: 'helsinki')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Black Bird"
    expect(page).to have_content "Oluthuone"
  end

  it "if none are returned by the API, it is informed at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kuopio").and_return(
        [ ]
    )

    visit places_path
    fill_in('city', with: 'kuopio')
    click_button "Search"

    expect(page).to have_content "No locations in kuopio"
  end
end