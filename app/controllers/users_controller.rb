class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers]
  
  def index
    @users = User.order(id: :desc).page(params[:page]).per(25)
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(id: :desc).page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      flash[:success] = 'ユーザを登録しました(users_controller)'
      redirect_to @user
    else
      flash.now[:danger]
      render :new
    end  
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
    
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  def likes
    if current_user == User.find(params[:id])
      @user = User.find(params[:id])
      @micropost_favorites = current_user.feed_microposts.order(id: :desc).page(params[:page])
    else
      @user = User.find(params[:id])
      @micropost_favorites = @user.feed_microposts.order(id: :desc).page(params[:page])
    end
  end
  
  
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
end
