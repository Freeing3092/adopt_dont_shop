class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @pet_search = Pet.search(params[:pet_name]) if !params[:pet_name].nil?
  end
  
  # Strong Params to DRY up code?
  def edit
    @application = Application.find(params[:id])
    if !params[:adopt].nil?
      @application.pets << Pet.find(params[:adopt])
    elsif !params[:good_owner_explanation].nil?
      @application[:description] = params[:good_owner_explanation]
      @application[:status] = "Pending"
      @application.save
    end
    redirect_to "/applications/#{@application.id}"
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