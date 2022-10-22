class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @pet_search = Pet.search(params[:pet_name]) if !params[:pet_name].nil?
    # binding.pry
  end
  
  def edit
    @application = Application.find(params[:id])
    @application.pets << Pet.find(params[:adopt])
    redirect_to "/applications/#{@application.id}"
  end
end