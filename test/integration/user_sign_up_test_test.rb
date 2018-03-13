require 'test_helper'

class UserSignUpTestTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "new user can sign up" do
    get new_user_registration_path

    assert_difference 'User.count', 1 do
      
      post user_registration_path, params: { user: { email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password",
                                         confirmed_at: Time.zone.now } }
                                                     
    end 
    assert_response :redirect
    follow_redirect!
    assert_not flash.empty?
    get root_path
    assert_equal User.last.email, "user@example.com"
  end
end
