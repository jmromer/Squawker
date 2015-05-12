class UsersController < ApplicationController

  before_action :signed_in_user, except: %i(new create show)
  before_action :admin_user, only: :destroy
  before_action :set_friendly_return_page, only: :show
  before_action :set_user, only: %i(edit update show following followers)
  before_action :correct_user, only: %i(edit update)

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      sign_in @user
      flash[:success] = 'Welcome to Squawker!'
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    user = User.find(params[:id])
    name = user.name
    user.destroy
    flash[:success] = "User #{name} deleted."
    redirect_to users_url
  end

  def show
    @squawks = @user.squawks.paginate(page: params[:page])
  end

  def following
    @title = 'Following'
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end

  def set_user
    @user = User.find(params[:id])
  end

  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
