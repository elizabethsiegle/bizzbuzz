require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get data" do
    get pages_data_url
    assert_response :success
  end

end
