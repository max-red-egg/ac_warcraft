require 'test_helper'

class RecruitDetectiveTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # include devise helper methods
  def setup
    @admin = users(:admin)
    @user = users(:user)
    @user2 = users(:user2)
    @instance_recruit = instances(:instance_recruit)
    @recruit_board = recruit_boards(:recruit_board1)
  end
  # 可以藉由招募的方式找隊友
  test "user can create a recruit request" do
    sign_in @user 
    # 按招募的時候可以產生一個招募訊息
    assert_difference 'RecruitBoard.count', 1 do
      post recruit_boards_path(instance_id: @instance_recruit.id)
    end
    assert_redirected_to recruit_boards_path
    # binding.pry
  end

  # 不可以招募自己
  test "cannot recruit by self" do
    sign_in @user
    assert_equal 'teaming', @instance_recruit.state
    assert_difference 'Invitation.count', 0 do
      post accept_recruit_board_path(@recruit_board)
    end
    assert_response :redirect
    @instance_recruit.reload
    assert_equal 'teaming', @instance_recruit.state
  end

  # 可以被招募
  test "can be recruited" do
    sign_in @user2
    assert_equal 'teaming', @instance_recruit.state
    assert @recruit_board.state
    assert_difference 'Invitation.count', 1 do
      # 招募的情況下組隊不會產生邀請通知,會產生組隊成功通知
      assert_difference 'Notification.count', 1 do
        post accept_recruit_board_path(@recruit_board)
      end
    end
    assert_response :redirect
    @instance_recruit.reload
    assert_equal 'in_progress', @instance_recruit.state
    @recruit_board.reload
    assert_not @recruit_board.state
  end

  # 發起者可以取消招募訊息
  test "user can cancel a recruit" do
    # 不可以取消別人發起的招募訊息
    sign_in @user2
    assert_difference 'RecruitBoard.count', 0 do
      delete recruit_board_path(@recruit_board)
    end
    # 可以取消自己的招募訊息
    sign_in @user
    assert_difference 'RecruitBoard.count', -1 do
      delete recruit_board_path(@recruit_board)
    end
  end
  
end
