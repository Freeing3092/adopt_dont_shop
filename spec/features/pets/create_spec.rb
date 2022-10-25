require 'rails_helper'

RSpec.describe 'pet creation' do
  before(:each) do
    @shelter = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
  end

  describe 'the pet new' do
    it 'renders the new form' do
      visit "/shelters/#{@shelter.id}/pets/new"

      expect(page).to have_content('New Pet')
      expect(find('form')).to have_content('Name')
      expect(find('form')).to have_content('Breed')
      expect(find('form')).to have_content('Age')
      expect(find('form')).to have_content('Adoptable')
    end
  end

  describe 'the pet create' do
    context 'given valid data' do
      it 'creates the pet and redirects to the shelter pets index' do
        visit "/shelters/#{@shelter.id}/pets/new"

        fill_in 'Name', with: 'Bumblebee'
        fill_in 'Age', with: 1
        fill_in 'Breed', with: 'Welsh Corgi'
        check 'Adoptable'
        click_button 'Save'
        
        expect(page).to have_current_path("/shelters/#{@shelter.id}/pets")
        expect(page).to have_content('Bumblebee')
      end
    end

    context 'given invalid data' do
      it 're-renders the new form' do
        visit "/shelters/#{@shelter.id}/pets/new"

        click_button 'Save'
        
        expect(page).to have_current_path("/shelters/#{@shelter.id}/pets/new")
        expect(page).to have_content("Error: Name can't be blank, Age can't be blank, Age is not a number")
      end
    end
  end

  describe 'length validations on new pet forms' do
    it 'will return error when too many characters are input into form' do
      visit "/shelters/#{@shelter.id}/pets/new"

      fill_in 'Name', with: 'Bumblebeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee'
      fill_in 'Age', with: 100
      fill_in 'Breed', with: 'Welsh CorgiWelsh CorgiWelsh CorgiWelsh CorgiWelsh Corgi'
      check 'Adoptable'
      click_button 'Save'
      
      expect(page).to have_current_path("/shelters/#{@shelter.id}/pets/new")
      expect(page).to have_content("Error: Name is too long (maximum is 30 characters)")
      expect(page).to have_content("Breed is too long (maximum is 30 characters)")
      expect(page).to have_content("Age is too long (maximum is 2 characters)")
    end
  end
end
