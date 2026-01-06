# Base controller for admin pages (logged in)
class Admin::BaseController < ApplicationController
  layout "application"
  
  before_action :authenticate_admin_user!
end

