class AuthorizeApiRequest
  def initialize(headers = {})
    @headers = headers
  end

  # Service entry point - return valid user object
  def call
    {
      visitor: visitor
    }
  end

  private

  attr_reader :headers

  def visitor
    # check if user is in the database
    # memoize user object
    register_class = decoded_auth_token[:type] == "vendor" ? Vendor : Guest
    @visitor_obj ||= register_class.find(decoded_auth_token[:visitor_id]) if decoded_auth_token
    return @visitor_obj, decoded_auth_token[:type]
    # handle user not found
  rescue ActiveRecord::RecordNotFound => e
    # raise custom error
    render json: {message: "Invalid token"}, status: :unauthorized
    # raise(
    #   ExceptionHandler::InvalidToken,
    #   ("#{Message.invalid_token}")
    # )
  end

  # decode authentication token
  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  # check for token in `Authorization` header
  def http_auth_header
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    else
      render json: {message: "No Authorization header"}, status: :unauthorized
    end
  end 
end
