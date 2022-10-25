class Application < ApplicationRecord
  has_many :pet_applications
  has_many :pets, through: :pet_applications
  
  validates :name, presence: true
  validates :street_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true

  validates :name, length: { maximum: 30 }
  validates :city, length: { maximum: 17 }
  validates :state, length: { maximum: 13 }
  validates :zip_code, length: { maximum: 5 }

end