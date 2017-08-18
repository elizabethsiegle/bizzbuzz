require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get connect" do
    get pages_connect_url
    assert_response :success
  end

end
