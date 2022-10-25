require 'rails_helper'

RSpec.describe 'the shelter show' do
  
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
  
  it "shows the shelter and all it's attributes" do
    shelter = Shelter.create(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
    pet = Pet.create(name: 'Scooby', age: 2, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)

    visit "/pets/#{pet.id}"

    expect(page).to have_content(pet.name)
    expect(page).to have_content(pet.age)
    expect(page).to have_content(pet.adoptable)
    expect(page).to have_content(pet.breed)
    expect(page).to have_content(pet.shelter_name)
  end

  it "allows the user to delete a pet" do
    shelter = Shelter.create(name: 'Mystery Building', city: 'Irvine CA', foster_program: false, rank: 9)
    pet = Pet.create(name: 'Scrappy', age: 1, breed: 'Great Dane', adoptable: true, shelter_id: shelter.id)

    visit "/pets/#{pet.id}"

    click_on("Delete #{pet.name}")

    expect(page).to have_current_path('/pets')
    expect(page).to_not have_content(pet.name)
  end
  
  it "when all pets have been approved on an application, those pets are no
  longer 'adoptable'" do
    
    visit "/admin/applications/#{@application_1.id}"
    click_on("Approve #{@pet_1.name}")
    click_on("Approve #{@pet_2.name}")
    
    visit "/pets/#{@pet_1.id}"
    expect(page).to have_content('false')
    expect(@application_1.pets.first.adoptable).to eq(false)
    visit "/pets/#{@pet_2.id}"
    
    expect(page).to have_content('false')
    expect(@application_1.pets.last.adoptable).to eq(false)
  end
end
