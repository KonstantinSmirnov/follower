require 'test_helper'

class TestWidgetControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get test_widget_index_url
    assert_response :success
  end

end
