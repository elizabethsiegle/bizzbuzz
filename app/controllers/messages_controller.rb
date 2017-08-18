class MessagesController < ApplicationController 
 skip_before_action :verify_authenticity_token
 
  def reply
    incoming_msg = params["Body"].downcase #convert to lowercase
    external_msg_num = params["From"]
    boot_twilio
    if incoming_msg == "inventory" then
      body_resp = "there is x-num left"
    elsif incoming_msg == "tweet" then
      body_resp = "post to twitter"
    else 
      body_resp = "else lol"
    end
    sms = @client.messages.create(
      :from => '+19094559811',
      :to => '+16505647814',
    	:body => body_resp
    	
    )
  end
  private
  def boot_twilio
    account_sid = 'AC358a60437a112c5c59d3b52da1f0dcc7'
    auth_token = 'e7ae1b711f733bae6c2647bd62154b77' 
    @client = Twilio::REST::Client.new account_sid, auth_token
  end
end
