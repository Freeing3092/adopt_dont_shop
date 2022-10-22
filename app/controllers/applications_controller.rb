class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
  end

  def new
  end

  def create
    application = Application.create(application_params)
    application[:status] = "In Progress"
    application.save
    
    redirect_to "/applications/#{application.id}"
  end

  def update
    
  end

  private
  def application_params
    params.permit(:name,
      :street_address,
      :city,
      :state,
      :zip_code,
      :description,
      :status,
      :id)
  end
end