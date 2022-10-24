class AdminSheltersController < ApplicationController

  def index
    @admin_shelters = Shelter.all.reverse_alphabetical_order

    @pending_applications = Shelter.pending_applications
  end
end