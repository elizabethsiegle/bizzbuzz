class MessagesController < ApplicationController 
 skip_before_action :verify_authenticity_token
 
  def reply
    message_body = params["Body"]
    from_number = params["From"]
    account_sid = 'AC358a60437a112c5c59d3b52da1f0dcc7'
    auth_token = 'e7ae1b711f733bae6c2647bd62154b77' #Rails.application.secrets.twilio_token
    @client = Twilio::REST::Client.new account_sid, auth_token
    sms = @client.messages.create(
    	body: "Hello there, thanks for texting me. Your number is #{from_number}.",
    	from: '+12028757342',
    	to: from_number,
    )
    
  end
 
  private
 
  def boot_twilio
    #account_sid = Rails.application.secrets.twilio_sid
    account_sid = 'AC358a60437a112c5c59d3b52da1f0dcc7'
    auth_token = 'e7ae1b711f733bae6c2647bd62154b77' #Rails.application.secrets.twilio_token
    @client = Twilio::REST::Client.new account_sid, auth_token
  end
end
