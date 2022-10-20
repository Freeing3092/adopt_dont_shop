class Application < ApplicationRecord
  has_many :pet_applications
  has_many :pets, through: :pet_applications
  # belongs_to :pet_application
  # belongs_to :pet
end