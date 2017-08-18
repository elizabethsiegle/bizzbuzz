#!/usr/bin/env ruby
require "rubygems"
require File.expand_path('../config/environment', File.dirname(__FILE__))
require "twitter"
require "figaro"

# puts "Checkpoint 1"
class tweet_client 
  def tweet
    client = Twitter::Client.new do |config|
      puts "Checkpoint 1v"
      config.consumer_key        = "MfnPEMYifabxIk9jtXW6toRqB"
      config.consumer_secret     = "m0Im5HBqZ4qzY5bUYWxoLuWdeHY5k0nkqcJ3Lk4sBDLzayMQhU"
      config.access_token        = "898183294491262977-IKKVqBHgWqy40mHSkcqxC0SmhRfgcf8"
      config.access_token_secret = "ukOdHI1OwyoG1chfowjhx24qI1kN6NdUkw6qenrhs0WBx"
    end
    puts "Checkpoint 2"

    # File.open("out.txt", 'w+') {|f| f.write("testme") }
    puts "Checkpoint 2v"
    String userUpdate = File.open("out.txt", 'rb') {|io| io.read}
    puts "Check p3"
    client.update(userUpdate)
    # client.update("Test Update2")
    puts "Checkpoint 3"
  end

  # pages = FbGraph2::User.me(APP_CONFIG['facebook_access_token']).accounts.first
  # shorten_url = "http://bit.ly/2wfp1Qq" #create a bit.ly link
  # pages.feed!(
  #     :message => "#{title}",
  #     :link => shorten_url,
  #     :description => "#{content[0..280]}"
  # )