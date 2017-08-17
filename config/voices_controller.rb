class VoicesController < ApplicationController 
  skip_before_action :verify_authenticity_token
  # twilio_num= '+12028757342'
  # account_sid = ENV['ACCOUNT_SID2'] 
  # auth_token = ENV['AUTH_TOKEN2'] 
  #@client = Twilio::REST::Client.new account_sid, auth_token
  def voice
    response = Twilio::TwiML::Response.new do |r|
      r.Say "Yay! You're on Rails!", voice: "alice"
      r.Sms "Well done building your first Twilio on Rails 5 app!"
      r.Play "http://linode.rabasa.com/cantina.mp3"
    end
    render :xml => response.to_xml
  end
end