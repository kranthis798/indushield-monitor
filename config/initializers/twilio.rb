account_sid = ENV['TWILIO_ACCT_SID']
auth_token = ENV['TWILIO_KEY']
source_number = ENV['TWILIO_PHONE_NUMBER']

Rails.application.config.twilio_client = TwilioClient.new(account_sid, auth_token, source_number)