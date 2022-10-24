require 'rails_helper'

RSpec.describe 'admin shelters index page' do
  before(:each) do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    
    @pet_1 = @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: false)
    @pet_2 = @shelter_2.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @pet_3 = @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    @pet_4 = @shelter_1.pets.create(name: 'Ann', breed: 'ragdoll', age: 5, adoptable: true)
    
    @application_1 = Application.create!(name:'John Lennon', street_address:'123 Fake Street', city:'Denver', state:'CO', zip_code:80204, description:"I'm Cool!", status:'Pending')
    @application_2 = Application.create!(name:'George Harrison', street_address:'123 Fake Street', city:'Denver', state:'CO', zip_code:80204, description:"I'm the quiet Beatle", status:'In Progress')
    @application_3 = Application.create!(name:'Paul McCartney', street_address:'123 Fake Street', city:'Denver', state:'CO', zip_code:80204, description:"I'm the quiet Beatle", status: 'Pending')
    
    @pet_application_1 = PetApplication.create!(pet_id: "#{@pet_1.id}", application_id: "#{@application_1.id}")
    @pet_application_2 = PetApplication.create!(pet_id: "#{@pet_2.id}", application_id: "#{@application_2.id}")
    @pet_application_3 = PetApplication.create!(pet_id: "#{@pet_3.id}", application_id: "#{@application_3.id}")
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

    it "shows section called 'Shelter's with Pending Applications'" do
    

      visit 'admin/shelters'

      expect(page).to have_content("Shelter's with Pending Applications")
      expect(page).to have_content("#{@shelter_1.name}", minimum:2)
      expect(page).to have_content("#{@shelter_3.name}", minimum:2)
      expect(page).to have_content("#{@shelter_2.name}", count:1) #should NOT have 'RGV animal shelter' under 'Shelter's with Pending Applications'
    end
  end
end
