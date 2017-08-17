class MessagesController < ApplicationController 
 skip_before_action :verify_authenticity_token
 
  def reply
    msg = params["Body"]
    non_twilio_num = params["From"]
    account_sid = ENV['ACCOUNT_SID2'] 
    auth_token = ENV['AUTH_TOKEN2'] 
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
