class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @pet_search = Pet.search(params[:pet_name]) if !params[:pet_name].nil?
    # binding.pry
  end
end