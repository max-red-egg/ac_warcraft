require 'test_helper'

class UserIndexTestTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @admin = users(:admin)
    @user = users(:user)
  end

  test "user_index" do
    sign_in @admin
    get users_path
    binding.pry
    assert_template 'users/index'
    assert_select 'nav.pagination', count: 1
    first_page_of_users = User.order('name').page(1).per(6)
    # binding.pry
    first_page_of_users.each do |user|
      
      # assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end
end
