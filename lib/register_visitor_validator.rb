class RegisterVisitorValidator

  def self.validate(payload, type)

    errors = []

    # Validate phone number
    msg = validate_phone_number(payload["phone_mobile"])
    errors << msg unless msg.nil?

    # Validate type
    msg = validate_type(type)
    errors << msg unless msg.nil?

    errors

  end

  def self.validate_phone_number(phone)

    if phone == nil || phone.empty?
      "No phone number provided."
    elsif /^\d{10}$/ !~ phone # Regex for only numbers and 10 characters long
      "Invalid phone number provided."
    end

  end

  def self.validate_type(type)

    if type == nil || type.empty?
      "No visitor type specified."
    elsif type.casecmp("vendor") != 0 && type.casecmp("visitor") != 0
      "Invalid visitor type provided."
    end

  end

end