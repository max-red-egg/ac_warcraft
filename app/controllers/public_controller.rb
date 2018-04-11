class PublicController < ApplicationController
  layout "public"
  skip_before_action :authenticate_user!

  def landing
  end

  def story
  end

end
