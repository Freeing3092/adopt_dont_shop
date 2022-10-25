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
    @application_1 = @pet_1.applications.create!(name:'John Lennon', street_address:'123 Fake Street', city:'Denver', state:'CO', zip_code:80204, status:'In Progress')
    @full_address = "#{@application_1.street_address} #{@application_1.city}, #{@application_1.state} #{@application_1.zip_code}"
    
    @application_2 = Application.create!(name:'George Harrison', street_address:'123 Fake Street', city:'Denver', state:'CO', zip_code:80204, description:"I'm the quiet Beatle", status:'Pending')
    @application_3 = Application.create!(name:'Paul McCartney', street_address:'123 Fake Street', city:'Denver', state:'CO', zip_code:80204, status:'In Progress')
    @shelter_1.pets.create(name: 'Lassie', breed: 'Rough Collie', age: 5, adoptable: true)
    @shelter_1.pets.create(name: 'Sparky', breed: 'Poodle', age: 7, adoptable: true)
  end
  describe 'as a visitor' do
    it "displays the attributes of an application" do
      visit "/applications/#{@application_1.id}"
      
      expect(page).to have_content("Name: #{@application_1.name}")
      expect(page).to have_content("Address: #{@full_address}")
      expect(page).to have_content("Description:")
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
      
      it "pet names that match my search each have a button to 'Adopt this pet'. 
      When I click this button I am taken back to the application show page
      where I see the pet I want to adopt listed under the application." do
        visit "/applications/#{@application_1.id}"
        
        fill_in "pet_name", with: "Lassie"
        click_on('Submit')
        
        find_button("Adopt this Pet").click

        expect(current_path).to eq("/applications/#{@application_1.id}")
        expect(page).to have_link("Lassie")
      end
      
      it "pet searches returns partial search matches" do
        visit "/applications/#{@application_1.id}"
        
        fill_in "pet_name", with: "Lass"
        click_on('Submit')
        
        expect(page).to have_content("Lassie")
        
      end
      
      it "pet searches returns case insensitive search matches" do
        visit "/applications/#{@application_1.id}"
        
        fill_in "pet_name", with: "lass"
        click_on('Submit')
        
        expect(page).to have_content("Lassie")
      end
      
      describe 'when I have added one or more pets to the application' do
        it "Then I see a section to submit my application. And in that section
        I see an input to enter why I would make a good owner for these pet(s).
        When I fill in that input and I click a button to submit this application
        then I am taken back to the application's show page and I see an indicator
        that the application is 'Pending' and I see all the pets that I want to
        adopt and I do not see a section to add more pets to this application" do
          visit "/applications/#{@application_1.id}"
          
          fill_in "pet_name", with: "Lassie"
          click_on('Submit')
          find_button("Adopt this Pet").click
          
          fill_in "good_owner_explanation", with: "I like to pet the dogs"
          find_button("Submit Application").click

          expect(current_path).to eq("/applications/#{@application_1.id}")
          
          expect(page).to have_content("Status: Pending")
          expect(page).to have_link("Lassie")
          expect(page).to_not have_content('Add a Pet to this Application')
        end
      end
      
      it "I do not see a section to submit an application if I have not added 
      any pets" do
        visit "/applications/#{@application_3.id}"
        
        expect(page).to_not have_button("Submit Application")
      end
    end
    
    describe 'if the application has been submitted' do
      it "I do not see the section to search pets by name" do
        visit "/applications/#{@application_2.id}"
      
        expect(page).to_not have_content('Add a Pet to this Application')
      end
    end
    describe "'Add a Pet to this Application' form length limit" do
      it 'returns an error when length is too long' do
        visit "applications/#{@application_1.id}"

        fill_in "pet_name" with: "lassielassielassielassielassielassielassielassie"
        
      end
    end
  end
end