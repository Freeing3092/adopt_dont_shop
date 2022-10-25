class PetApplication < ApplicationRecord
  belongs_to :application
  belongs_to :pet
  
  def rejected_pets?
    apps = PetApplication.joins(:application).where(:application_id => self.application_id).where(["pet_applications.status = ?", 'Reject'])
    apps.count > 0
  end
  
  def null_pets?
    apps = PetApplication.joins(:application).where(:application_id => self.application_id).where(status: [nil, ""])
    apps.count > 0
  end
end