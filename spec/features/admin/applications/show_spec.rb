require 'rails_helper'

RSpec.describe 'admin application show page' do
  before :each do
    @shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    @shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
    @shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
    @shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
    @shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
    @shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)
    
    @pet_1 = @shelter_1.pets.first
    
    @application_1 = @pet_1.applications.create!(name:'John Lennon', street_address:'123 Fake Street', city:'Denver', state:'CO', zip_code:80204, status:'Pending')
    @application_2 = Application.create!(name:'George Harrison', street_address:'123 Fake Street', city:'Denver', state:'CO', zip_code:80204, description:"I'm the quiet Beatle", status:'Pending')
    @application_3 = Application.create!(name:'Paul McCartney', street_address:'123 Fake Street', city:'Denver', state:'CO', zip_code:80204, status:'In Progress')
    @pet_2 = @shelter_1.pets.create(name: 'Lassie', breed: 'Rough Collie', age: 5, adoptable: true)
    @shelter_1.pets.create(name: 'Sparky', breed: 'Poodle', age: 7, adoptable: true)
    
    @application_1.pets << @pet_2
    @application_2.pets << @pet_1
    @application_2.pets << @pet_2
    
    @application_1_pet_1 = @application_1.pet_applications.first
    @application_1_pet_2 = @application_1.pet_applications.last
    @application_2_pet_1 = @application_2.pet_applications.first
    @application_2_pet_2 = @application_2.pet_applications.last
  end
  describe 'as a visitor' do
    it "For every pet that the application is for, I see a button to approve
    the application for that specific pet. When I click that button then I'm
    taken back to the admin application show page. Next to the pet that I
    approved, I do not see a button to approve this pet And instead I see an
    indicator next to the pet that they have been approved" do
      
      visit "/admin/applications/#{@application_1.id}"
      
      expect(page).to have_button("Approve #{@pet_1.name}")
      expect(page).to have_button("Approve #{@pet_2.name}")
      
      click_on("Approve #{@pet_2.name}")
      
      expect(current_path).to eq("/admin/applications/#{@application_1.id}")
      expect(page).to_not have_button("Approve #{@pet_2.name}")
      expect(page).to have_content("#{@pet_2.name} Approved")
    end
    
    it "For every pet that the application is for, I see a button to reject the
    application for that specific pet When I click that button Then I'm taken
    back to the admin application show page And next to the pet that I rejected,
    I do not see a button to approve or reject this pet And instead I see an
    indicator next to the pet that they have been rejected." do
      visit "/admin/applications/#{@application_1.id}"
      
      expect(page).to have_button("Approve #{@pet_1.name}")
      expect(page).to have_button("Approve #{@pet_2.name}")
      
      click_on("Reject #{@pet_2.name}")
      
      expect(current_path).to eq("/admin/applications/#{@application_1.id}")
      expect(page).to_not have_button("Approve #{@pet_2.name}")
      expect(page).to_not have_button("Reject #{@pet_2.name}")
      expect(page).to have_content("#{@pet_2.name} Rejected")
    end
    
    it "Accepting or rejecting an application for a pet does not impact the
    fields to approve or reject other applications for the same pet." do
      visit "/admin/applications/#{@application_1.id}"
      
      expect(page).to have_button("Approve #{@pet_1.name}")
      expect(page).to have_button("Approve #{@pet_2.name}")
      
      click_on("Reject #{@pet_1.name}")
      click_on("Approve #{@pet_2.name}")
      
      visit "/admin/applications/#{@application_2.id}"
      
      expect(page).to have_button("Approve #{@pet_1.name}")
      expect(page).to have_button("Reject #{@pet_1.name}")
      expect(page).to have_button("Approve #{@pet_2.name}")
      expect(page).to have_button("Reject #{@pet_2.name}")
    end
    
    it "When all the pets on an application have been approved, the application
    status is changed to 'Approved'." do
      visit "/admin/applications/#{@application_1.id}"
      
      click_on("Approve #{@pet_1.name}")
      click_on("Approve #{@pet_2.name}")
      
      expect(current_path).to eq("/admin/applications/#{@application_1.id}")
      
      expect(page).to have_content("Status: Approved")
    end
    
    it "When all the pets on an application have been either approved or rejected, 
    and at least 1 pet has been rejected, the application status is changed to 
    'Rejected'." do
      visit "/admin/applications/#{@application_1.id}"
      
      click_on("Reject #{@pet_1.name}")
      click_on("Approve #{@pet_2.name}")
      
      expect(current_path).to eq("/admin/applications/#{@application_1.id}")
      
      expect(page).to have_content("Status: Rejected")
    end
    
  end
end