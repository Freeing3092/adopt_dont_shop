class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @pet_search = Pet.search(params[:pet_name]) if !params[:pet_name].nil?
  end
  
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
end