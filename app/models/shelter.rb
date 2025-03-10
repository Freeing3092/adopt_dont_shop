class Shelter < ApplicationRecord
  has_many :pets, dependent: :destroy
  
  validates :name, presence: true
  validates :rank, presence: true, numericality: true
  validates :city, presence: true
  validates :name, length: { maximum: 35 }
  validates :city, length: { maximum: 19 }
  validates :rank, length: { maximum: 3 }

  
  def self.order_by_recently_created
    order(created_at: :desc)
  end

  def self.order_by_number_of_pets
    select("shelters.*, count(pets.id) AS pets_count")
      .joins("LEFT OUTER JOIN pets ON pets.shelter_id = shelters.id")
      .group("shelters.id")
      .order("pets_count DESC")
  end

  def pet_count
    pets.count
  end

  def adoptable_pets
    pets.where(adoptable: true)
  end

  def alphabetical_pets
    adoptable_pets.order(name: :asc)
  end

  def shelter_pets_filtered_by_age(age_filter)
    adoptable_pets.where('age >= ?', age_filter)
  end

  def self.reverse_alphabetical_order
    find_by_sql("select * from shelters order by name desc") 
  end

  def self.pending_applications
    Pet.joins(:applications, :shelter).select('shelters.*').where("applications.status = ?", "Pending").distinct.order("shelters.name")
  end
end
