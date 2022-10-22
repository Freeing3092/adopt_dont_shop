require 'rails_helper'

RSpec.describe 'admin shelters index page' do
  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
  end
  describe 'As a visitor' do
    it 'shows all shelters in the system in reverse alphabetical order by name' do

      visit 'admin/shelters'

      expect(page).to have_content('Aurora shelter')
      expect(page).to have_content('RGV animal shelter')
      expect(page).to have_content('Fancy pets of Colorado')
      expect(@shelter_2.name).to appear_before(@shelter_3.name)
      expect(@shelter_3.name).to appear_before(@shelter_1.name)
      expect(@shelter_2.name).to appear_before(@shelter_1.name)
    end
  end
end