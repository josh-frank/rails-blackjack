require "test_helper"

class RoundsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get rounds_show_url
    assert_response :success
  end
end
