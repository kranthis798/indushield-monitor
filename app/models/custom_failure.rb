class CustomFailure < Devise::FailureApp
  def respond
    if request.format == :json or request.content_type == 'application/json' # == :json does not works here
      json_failure
    else
      super
    end
  end

  def json_failure
    self.status = 401
    self.content_type = 'application/json'
    self.response_body = {"success"=> false, "message" =>"Authentication Error"}.to_json
  end
end