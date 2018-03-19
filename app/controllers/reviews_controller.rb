class ReviewsController < ApplicationController

  def show 
  end

  def create
    # create review

    # 參數說明
    #  user: 被評論者
    #  user_instance: 被評論者與副本的關聯table, review是依附在上面
    #  instance: 任務副本
    # reviews_params[:comment]: 評論內容
    # reviews_params[:instnace_id]: 副本id
    # params[:user_id]: 被評論者id
    user = User.find(params[:user_id])
    user_instance = UserInstance.find_by(instance_id: review_params[:instance_id],user_id: params[:user_id])
    instance = Instance.find(review_params[:instance_id])

    # 如果已經被current_user評論過，則跳出
    if user.be_reviewed_from?(current_user,instance)
      flash[:alert] = '你已經評論過 #{user.name} !'
      redirect_back(fallback_location: root_path)
    end

    # 如果current_user是member，而且任務已經結束，才可以新增
    if instance.is_member?(current_user) && ( instance.state == 'complete' || instance.state == 'abort' )
      # 新增review
      review = user_instance.reviews.create(comment: review_params[:comment])
      review.reviewer = current_user
      review.save
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = '無法送出評價'
      redirect_back(fallback_location: root_path)
    end
  end

    private
  def review_params
    params.require(:review).permit(:comment,:instance_id)
  end
end
