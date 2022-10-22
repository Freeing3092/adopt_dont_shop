require 'rails_helper'

RSpec.describe 'Applications show page' do
  before :each do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    
    @pet_1 = @shelter_1.pets.first
    @application_1 = @pet_1.applications.create!(name:'John Lennon', street_address:'123 Fake Street', city:'Denver', state:'CO', zip_code:80204, description:"I'm a member of the Beatles", status:'In Progress')
    @full_address = "#{@application_1.street_address} #{@application_1.city}, #{@application_1.state} #{@application_1.zip_code}"
    
    @application_2 = Application.create!(name:'George Harrison', street_address:'123 Fake Street', city:'Denver', state:'CO', zip_code:80204, description:"I'm the quiet Beatle", status:'Pending')
    @shelter_1.pets.create(name: 'Lassie', breed: 'Rough Collie', age: 5, adoptable: true)
    @shelter_1.pets.create(name: 'Sparky', breed: 'Poodle', age: 7, adoptable: true)
  end
  describe 'as a visitor' do
    it "displays the attributes of an application" do
      visit "/applications/#{@application_1.id}"
      
      expect(page).to have_content("Name: #{@application_1.name}")
      expect(page).to have_content("Address: #{@full_address}")
      expect(page).to have_content("Description: #{@application_1.description}")
      expect(page).to have_content("Status: #{@application_1.status}")
      
      expect(page).to have_link("#{@pet_1.name}")
    end
    
    describe "if that application has not been submitted" do
      it "then I see a section to 'Add a Pet to this Application'" do
        visit "/applications/#{@application_1.id}"
        
        expect(page).to have_content("Add a Pet to this Application")
      end
      
      it "In that section I see an input where I can search for Pets by name.
      When I fill in this field with a Pet's name and hit 'Submit' then I am taken back to the
      application show page. And under the search bar I see any Pet whose name
      matches my search" do
        visit "/applications/#{@application_1.id}"
        
        fill_in "pet_name", with: "Lassie"
        click_on('Submit')
        
        expect(current_path).to eq("/applications/#{@application_1.id}")
        expect(page).to have_content("Lassie")
        expect(page).to_not have_content('Sparky')
      end
    end
    
    describe 'if the application has been submitted' do
      it "I do not see the section to search pets by name" do
        visit "/applications/#{@application_2.id}"
      
        expect(page).to_not have_content('Add a Pet to this Application')
      end
    end
  end
end