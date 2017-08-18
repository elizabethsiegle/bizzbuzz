class MessagesController < ApplicationController 
  skip_before_action :verify_authenticity_token
  require 'unirest'
  require 'json'
  require 'ostruct'
  require 'openssl'
  require 'twitter'
  require "rubygems"
  #require_relative 'tweet_controller.rb'
  #OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

  #require "../bin/bot.rb"
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
    'Content-Type' => 'application/json'
  }
            
  def list_inventory 
    #response = Unirest.get CONNECT_HOST + '/v1/' + LOCATION_ID + '/items',
                     # headers: REQUEST_HEADERS
    puts REQUEST_HEADERS
    list_inv_code = '[
    {
        "fees": [],
        "variations": [
            {
                "inventory_alert_type": "LOW_QUANTITY",
                "track_inventory": true,
                "pricing_type": "FIXED_PRICING",
                "id": "Z2T7YBSEVGSKE6R6K444FRVF",
                "name": "Regular",
                "price_money": {
                    "currency_code": "USD",
                    "amount": 100
                },
                "ordinal": 1,
                "item_id": "KASTPQBETX5MRPHPNBZBFPWZ",
                "inventory_alert_threshold": 5
            }
        ],
        "available_for_pickup": false,
        "available_online": false,
        "visibility": "PRIVATE",
        "id": "KASTPQBETX5MRPHPNBZBFPWZ",
        "description": "",
        "name": "Lays Wavy Potato Chips",
        "category_id": "TQJZP3KDHUVRNL5O7GF3OUQH",
        "category": {
            "id": "TQJZP3KDHUVRNL5O7GF3OUQH",
            "name": "CHIPS"
        },
        "type": "NORMAL"
    },
    {
        "fees": [],
        "variations": [
            {
                "inventory_alert_type": "LOW_QUANTITY",
                "track_inventory": true,
                "pricing_type": "FIXED_PRICING",
                "id": "ZBFW2TSM3LQPL2TBJBKTFWUA",
                "name": "Regular",
                "price_money": {
                    "currency_code": "USD",
                    "amount": 100
                },
                "sku": "",
                "ordinal": 1,
                "item_id": "HYTH6I4JP4ORYGXTEPNJP4UB",
                "inventory_alert_threshold": 2
            }
        ],
        "available_for_pickup": false,
        "available_online": false,
        "visibility": "PRIVATE",
        "id": "HYTH6I4JP4ORYGXTEPNJP4UB",
        "description": "red delicious ",
        "name": "Apples",
        "category_id": "C3V34P5IZLJCASLTRTGX4GTN",
        "category": {
            "id": "C3V34P5IZLJCASLTRTGX4GTN",
            "name": "FRUIT"
        },
        "type": "NORMAL"
    }
]'
    json_object = JSON.parse(list_inv_code, object_class: OpenStruct)
    #json_object.inspect
    puts json_object[0].id
    return json_object
  end

  def get_quantity
    location_id = list_inventory
    quant_code = '[
    {
        "variation_id": "Z2T7YBSEVGSKE6R6K444FRVF",
        "quantity_on_hand": 15
    },
    {
        "variation_id": "ZBFW2TSM3LQPL2TBJBKTFWUA",
        "quantity_on_hand": 1
    }
]'
      json_object = JSON.parse(quant_code, object_class: OpenStruct)
      puts json_object[0].quantity_on_hand
      return json_object[0].quantity_on_hand
  end
 
  def reply
    json_object = list_inventory
    quantity_on_hand = get_quantity
    incoming_msg = params["Body"] #convert to lowercase
    external_msg_num = params["From"]
    boot_twilio
    if incoming_msg == "Get inv" then
      puts quantity_on_hand
      if quantity_on_hand > json_object[0].variations[0].inventory_alert_threshold then 
        body_resp = "inventory for " + json_object[0].name + " is low"
      else 
        body_resp = "In stock"
      end
    elsif incoming_msg == "Tweet" then
      body_resp = "Reply with your tweet message like \"t:come to our store\""
    elsif incoming_msg == "t: come to our store" then
      #tweet
      puts incoming_msg
      @clientt = Twitter::REST::Client.new do |config|
        config.consumer_key        = "MfnPEMYifabxIk9jtXW6toRqB"
        config.consumer_secret     = "m0Im5HBqZ4qzY5bUYWxoLuWdeHY5k0nkqcJ3Lk4sBDLzayMQhU"
        config.access_token        = "898183294491262977-IKKVqBHgWqy40mHSkcqxC0SmhRfgcf8"
        config.access_token_secret = "ukOdHI1OwyoG1chfowjhx24qI1kN6NdUkw6qenrhs0WBx"
      end
      body_resp = "tweeting"
      #@tweets = incoming_msg
      puts "checkpoint1"
      clientt.update(incoming_msg)
      puts "checkpoint2"
    else
      body_resp="Invalid SMS Request"
    end
    sms = @client.messages.create(
      :from => '+19094559811',
      :to => '+15129429154',
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