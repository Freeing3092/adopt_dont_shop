# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
shelter_1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
shelter_2 = Shelter.create(name: 'RGV animal shelter', city: 'Harlingen, TX', foster_program: false, rank: 5)
shelter_3 = Shelter.create(name: 'Fancy pets of Colorado', city: 'Denver, CO', foster_program: true, rank: 10)
shelter_1.pets.create(name: 'Mr. Pirate', breed: 'tuxedo shorthair', age: 5, adoptable: true)
shelter_1.pets.create(name: 'Clawdia', breed: 'shorthair', age: 3, adoptable: true)
shelter_3.pets.create(name: 'Lucille Bald', breed: 'sphynx', age: 8, adoptable: true)

application_1 = Application.create!(name:'John Lennon', street_address:'123 Fake Street', city:'Denver', state:'CO', zip_code:80204)
application_2 = Application.create!(name:'George Harrison', street_address:'123 Fake Street', city:'Denver', state:'CO', zip_code:80204, description:"I'm the quiet Beatle", status:'Pending')
application_3 = Application.create!(name:'Paul McCartney', street_address:'123 Fake Street', city:'Denver', state:'CO', zip_code:80204, status: 'In Progress')

shelter_1.pets.create(name: 'Lassie', breed: 'Rough Collie', age: 5, adoptable: true)
shelter_1.pets.create(name: 'Sparky', breed: 'Poodle', age: 7, adoptable: true)