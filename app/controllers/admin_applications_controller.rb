class AdminApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
  end
  
  def edit
    pet_application = PetApplication.find(params[:application])
    pet_application.update({status: params[:commit].split.first})
    redirect_to "/admin/applications/#{pet_application.application_id}"
  end
end