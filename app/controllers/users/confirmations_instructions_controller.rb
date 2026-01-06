class Users::ConfirmationsInstructionsController < ApplicationController
  layout "auth"
  
  def show
    # This page shows instructions after registration
    # Email is passed as parameter if available
    @email = params[:email]
  end
end

