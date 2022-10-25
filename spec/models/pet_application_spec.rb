require "rails_helper"

RSpec.describe PetApplication do
  describe 'relationships' do
    it { should belong_to(:application)}
    it { should belong_to(:pet)}
  end
  
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
    
    @application_3.pets << @pet_1
    @application_3.pets << @pet_2
    
    @application_1_pet_1 = @application_1.pet_applications.first
    @application_1_pet_2 = @application_1.pet_applications.last
    @application_2_pet_1 = @application_2.pet_applications.first
    @application_2_pet_2 = @application_2.pet_applications.last
    @application_3_pet_1 = @application_3.pet_applications.last
  end
  
  describe 'instance methods' do
    it "#rejected_pets? returns boolean value indicating if any pets have
    been rejected on an application" do
      @application_1_pet_1.update({status: 'Approve'})
      @application_1_pet_2.update({status: 'Approve'})
      
      expect(@application_1_pet_1.rejected_pets?).to eq(false)
      
      @application_2_pet_1.update({status: 'Reject'})
      @application_2_pet_2.update({status: 'Approve'})
      
      expect(@application_2_pet_2.rejected_pets?).to eq(true)
    end
    
    it "#null_pets? returns boolean value indicating if any pets have
    been not been reject or approved on an application" do
      @application_1_pet_1.update({status: 'Approve'})
      @application_1_pet_2.update({status: 'Approve'})
      
      expect(@application_1_pet_1.null_pets?).to eq(false)
      
      @application_1_pet_1.update({status: 'Reject'})
      
      expect(@application_3_pet_1.null_pets?).to eq(true)
    end
  end
end