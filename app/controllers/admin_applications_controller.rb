class AdminApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
  end
  
  def edit
    pet_application = PetApplication.find(params[:application])
    pet_application.update({status: params[:commit].split.first})
    update_application_status(pet_application)
    redirect_to "/admin/applications/#{pet_application.application_id}"
  end
  
  def update_application_status(pet_application)
    application = pet_application.application
    if !pet_application.rejected_pets? && !pet_application.null_pets?
      application.update({status: 'Approved'})
    elsif pet_application.rejected_pets? && !pet_application.null_pets?
      application.update({status: 'Rejected'})
    end
  end
end