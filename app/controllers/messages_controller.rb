class MessagesController < ApplicationController 
 skip_before_action :verify_authenticity_token
 
  def reply
    msg = params["Body"]
    non_twilio_num = params["From"]
    account_sid = 'AC358a60437a112c5c59d3b52da1f0dcc7'
    auth_token = 'e7ae1b711f733bae6c2647bd62154b77' 
    @client = Twilio::REST::Client.new account_sid, auth_token
    if msg == "hi" then
      body_resp = "i like warm hugs"
    elsif msg == "heyo" then
      body_resp = "shame on you shame on your cow"
    else 
      body_resp="we know the wayyy"
    sms = @client.messages.create(
    	body: body_resp,
    	from: '+12028757342',
    	to: non_twilio_num,
    )
    end
  end
  private
end
