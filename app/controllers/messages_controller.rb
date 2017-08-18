class MessagesController < ApplicationController 
  skip_before_action :verify_authenticity_token
  require 'unirest'
  require 'json'
  require 'ostruct'
  # Replace this value with your application's personal access token,
  # available from your application dashboard (https://connect.squareup.com/apps)
  ACCESS_TOKEN = 'sq0atp-PXtIb9nroEojtUkVGed3KQ'

  # The ID of the location you want to create an item for.
  # See payments-report.rb for an example of getting a business's location IDs.
  LOCATION_ID = 'VZXNSMR4PRWT5'

  # The base URL for every Connect API request
  CONNECT_HOST = 'https://connect.squareup.com'

  # Standard HTTP headers for every Connect API request
  REQUEST_HEADERS = {
    'Authorization' => 'Bearer ' + ACCESS_TOKEN,
    'Accept' => 'application/json'
    # 'Content-Type' => 'application/json'
  }
                    
  def list_inventory 
    response = Unirest.get CONNECT_HOST + '/v1/' + LOCATION_ID + '/items',
                      headers: REQUEST_HEADERS
    puts REQUEST_HEADERS
    if response.code == 200
      #puts 'Successfully created item:'
      #String responseString = String.new(response.body)
      json_object = JSON.parse(JSON.pretty_generate(response.body), object_class: OpenStruct)
      #json_object.inspect
      puts json_object[0].id
      return json_object
    else
      puts 'location does not exist: list inventory'
      puts response.body
      return nil
    end
  end

  def get_quantity
    location_id = list_inventory
    response = Unirest.get CONNECT_HOST + '/v1/' + LOCATION_ID + '/inventory',
                      headers: REQUEST_HEADERS
    if response.code == 200
      #puts 'Successfully created item:'
      #String responseString = String.new(response.body)
      json_object = JSON.parse(JSON.pretty_generate(response.body), object_class: OpenStruct)
      #json_object.inspect
      puts json_object[0].quantity_on_hand
      return json_object[0].quantity_on_hand
    else
      puts 'location does not exist: get quantity'
      puts response.body
      return nil
    end
  end
 
  def reply
    json_object = list_inventory
    quantity_on_hand = get_quantity
    
    incoming_msg = params["Body"].downcase #convert to lowercase
    external_msg_num = params["From"]
    boot_twilio
    if incoming_msg == "get inv" then
      if quantity_on_hand > json_object[0].variations[0].inventory_alert_threshold then 
        body_resp = "inventory for" + json_object[0].name + "is low"
      else 
        body_resp = "In stock"
      end
    elsif incoming_msg == "tweet" then
      body_resp = "Reply with your tweet message"
    else
      body_resp="Invalid SMS Request"
    end
    sms = @client.messages.create(
      :from => '+19094559811',
      :to => external_msg_num,
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