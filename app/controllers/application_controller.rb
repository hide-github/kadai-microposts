class ApplicationController < ActionController::Base
  #ここで記述されたメソッドは全てのControllerで使用可能になる
  include SessionsHelper
  
  private
  
  def require_user_logged_in
    unless logged_in?
    redirect_to login_url
    end
  end
  
  def counts(user)
    @count_microposts = user.microposts.count
  end
end
