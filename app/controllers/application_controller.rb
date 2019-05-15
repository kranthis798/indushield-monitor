class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery with: :exception
  before_action :store_current_location, :unless => :devise_controller?
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized


  private

  def store_current_location
    store_location_for(:user, request.url)
  end

  # Send 'em back where they came from with a slap on the wrist
  def user_not_authorized
    redirect_to request.referrer.presence || root_path, :alert => 'You are not authorized to complete that action.'
  end
  
end
