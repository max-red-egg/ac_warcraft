class ReviewsController < ApplicationController
  before_action :authenticate_user!
  def show 
  end


  def submit
    review = Review.find(params[:id])
    if review.reviewer != current_user
      flash[:alert] = '::review:: 存取禁止'
      redirect_back(fallback_location: root_path)
    
    elsif review.submit
      flash[:alert] = '你已經送過評價，無法再次評論'
      redirect_back(fallback_location: root_path)
    else
      if review.update!(comment: review_params[:comment], rating: review_params[:rating].to_i, submit: true)
        flash[:notice] = '成功送出評價'
        redirect_back(fallback_location: root_path)
      else
        flash[:alert] = '::review:: something wrong!'
        redirect_back(fallback_location: root_path)
      end
    end
  end


    private
  def review_params
    params.require(:review).permit(:comment,:rating)
  end
end
