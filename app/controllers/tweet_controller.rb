class TweetController < ApplicationController

require "rubygems"
require "twitter"

  def tweet
    String userUpdate = File.open("out.txt", 'rb') {|io| io.read}
    @tweets = client.update(userUpdate)
  end
end

  # pages = FbGraph2::User.me(APP_CONFIG['facebook_access_token']).accounts.first
  # shorten_url = "http://bit.ly/2wfp1Qq" #create a bit.ly link
  # pages.feed!(
  #     :message => "#{title}",
  #     :link => shorten_url,
  #     :description => "#{content[0..280]}"
  # )