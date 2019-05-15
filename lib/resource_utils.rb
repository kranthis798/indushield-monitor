module ResourceUtils
  def check_for_api_key
    if api_key.blank?
      uuid = SecureRandom.uuid
      self.api_key = uuid
    end
  end

  def confirm_api_key_present
    if id.nil?
      p "ERROR! confirm_api_key_present() We haven't saved this #{self.class.name} record yet named: #{try(:name)}"
      return
    end
    if api_key.blank?
      new_uuid = SecureRandom.uuid
      p "Warning: ResourceUtils: Generated UUID #{new_uuid} for resource #{id}"
      update api_key:new_uuid
    end
    api_key
  end

end