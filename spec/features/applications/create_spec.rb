require 'rails_helper'

RSpec.describe 'the application creation' do
  it 'displays a link to start an application' do
    visit '/pets'

    click_link("Start an Application")

    expect(page).to have_current_path("/applications/new")
  end

  it 'can create a new application' do
    visit '/applications/new'

    fill_in 'Name', with: 'John Lennon'
    fill_in 'Street address', with: '123 Fake Street'
    fill_in 'City', with: 'Denver'
    fill_in 'State', with: 'Colorado'
    fill_in 'Zip code', with: 80204

    click_button 'Submit'

    new_application_id = Application.last.id
    expect(page).to have_current_path("/applications/#{new_application_id}")
    expect(page).to have_content("Name: John Lennon")
    expect(page).to have_content("Address: 123 Fake Street Denver, Colorado 80204")
    expect(page).to have_content("Status: In Progress")
  end

  describe 'takes you back to new application page when form not completely filled out' do
    it 'shows that visitor will need to fill those empty fields' do
      visit '/applications/new'

      fill_in 'Street address', with: '123 Fake Street'
      fill_in 'City', with: 'Denver'
      fill_in 'State', with: 'Colorado'
      fill_in 'Zip code', with: 80204

      click_button 'Submit Application'
      
      expect(page).to have_current_path("/applications/new")
      expect(page).to have_content("Error: Name can't be blank")
      expect(page).to have_button("Submit Application")
    end
  end

  describe 'test maximum character validations' do
    it 'will return an error message' do
      visit '/applications/new'

      fill_in 'Name', with: 'BobBobBobBobBobBobBobBobBobBobBobBob'
      fill_in 'Street address', with: '123 Fake Street123 Fake Street123 Fake Street'
      fill_in 'City', with: 'DenverDenverDenverDenverDenver'
      fill_in 'State', with: 'ColoradoColoradoColoradoColorado'
      fill_in 'Zip code', with: 802048020480204

      click_button 'Submit Application'
      
      expect(page).to have_content("Error: Name is too long (maximum is 30 characters)")
      expect(page).to have_content("City is too long (maximum is 17 characters)")
      expect(page).to have_content("State is too long (maximum is 13 characters)")
      expect(page).to have_content("Zip code is too long (maximum is 5 characters)")
      expect(page).to have_current_path("/applications/new")
      expect(page).to have_button("Submit Application")
    end
  end
end