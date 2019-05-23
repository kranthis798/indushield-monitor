class NotifierMailer < ApplicationMailer
  
  def visit_alert(message, to_email)
    @content = message
    mail(to:to_email, subject:"Visit Alert",  body: @content, content_type: "text/html")
  end

end