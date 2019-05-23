class Api::ApiController < ApplicationController
  
  skip_before_action :verify_authenticity_token
  attr_reader :current_visitor, :visitor_type
  
  def authenticate
  	password = request.headers["auth"]
    if password.blank? || password != "51214aef143848e09f7e9475c9624cbb"
      render json: {error:"Unable to process request"}, status: 401
    end
  end

  def authorize_request
    header = request.headers['Authorization']
    if header.present?
	    header = header.split(' ').last if header
	    begin
	      decoded_auth_token = JsonWebToken.decode(header)
	      visitor_class = decoded_auth_token[:type] == "vendor" ? Vendor : Guest
	      @current_visitor ||= visitor_class.find(decoded_auth_token[:visitor_id]) if decoded_auth_token
	      @visitor_type = decoded_auth_token[:type]
	    rescue ActiveRecord::RecordNotFound => e
	      render json: { message: e.message }, status: :unauthorized
	    rescue JWT::DecodeError => e
	      render json: { message: "Invalid token" }, status: :unauthorized
	    end
	else
      render json: { message: "No Authorization header" }, status: :unauthorized
    end
  end

end