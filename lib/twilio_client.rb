class TwilioClient
    attr_reader :account_sid, :auth_token, :source_number
    
    def initialize(account_sid, auth_token, source_number)
      @account_sid = account_sid
      @auth_token = auth_token
      @source_number = source_number
    end

    def send_sms(msg, num)
        #p "sending Twilio message: #{msg} to number: #{num}"
        Twilio::REST::Client.new(account_sid, auth_token).api.account.messages.create({
            from: source_number,
            to: num,
            body: msg,
        })
    end
end