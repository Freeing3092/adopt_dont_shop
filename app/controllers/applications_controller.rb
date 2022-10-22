class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
  end

  def index
  end

  def new
  end

  def create
    application = Application.create(application_params)
    application[:status] = "In Progress"
    if application[:id].present?
      application.save
      redirect_to "/applications/#{application.id}"
    else
      redirect_to "/applications/new"
      flash[:alert] = "Application not submitted. Required information missing."
    end
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