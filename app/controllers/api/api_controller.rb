class Api::ApiController < ApplicationController
  before_action :authenticate
  skip_before_action :verify_authenticity_token
  
  def authenticate
  	password = request.headers["auth"]
    if password.blank? || password != "51214aef143848e09f7e9475c9624cbb"
      render json: {error:"Unable to process request"}, status: 401
    end
  end
end