class CallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.from_omniauth(request.env["omniauth.auth"])
    # binding.pry
    if @user.id
      sign_in_and_redirect @user
    else
      redirect_back(fallback_location: root_path)
      flash[:alert] = "此帳號已被使用，如果你是此帳號擁有者請用一般登入"
    end
  end
end