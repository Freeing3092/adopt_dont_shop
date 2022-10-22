require 'rails_helper'

RSpec.describe 'the application creation' do
  it 'displays a link to start an application' do
    # shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    # pet_1 = Pet.create(adoptable: true, age: 1, breed: 'sphynx', name: 'Lucille Bald', shelter_id: shelter.id)
    # pet_2 = Pet.create(adoptable: true, age: 3, breed: 'doberman', name: 'Lobster', shelter_id: shelter.id)

    visit '/pets'

    click_link("Start an Application")

    expect(page).to have_current_path("/applications/new")
  end

  it 'can create a new application' do

    visit '/applications/new'

    # save_and_open_page
    fill_in 'Name', with: 'John Lennon'
    fill_in 'Street address', with: '123 Fake Street'
    fill_in 'City', with: 'Denver'
    fill_in 'State', with: 'Colorado'
    fill_in 'Zip code', with: 80204
    fill_in 'Description', with: "I'm a member of the Beatles"

    click_button 'Submit'

    new_application_id = Application.last.id
    expect(page).to have_current_path("/applications/#{new_application_id}")
    expect(page).to have_content("Name: John Lennon")
    expect(page).to have_content("Address: 123 Fake Street Denver, Colorado 80204")
    expect(page).to have_content("Description: I'm a member of the Beatles")
    expect(page).to have_content("Status: In Progress")
  end
end