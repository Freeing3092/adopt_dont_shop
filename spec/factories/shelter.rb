FactoryBot.define do
  factory :shelter, class: Shelter do
    name { Faker::Fantasy::Tolkien.character }
    foster_program { Faker::Boolean.boolean }
    city { Faker::Address.city }
    rank { Faker::Number.between(from: 1, to: 5) }
  end
end