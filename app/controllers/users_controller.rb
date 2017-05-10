# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :signed_in_user, except: %i[new create show]
  before_action :admin_user, only: :destroy
  before_action :set_friendly_return_page, only: :show
  before_action :correct_user, only: %i[edit update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Squawker!"
      redirect_to @user
    else
      render :new
    end
  end

  def edit
    @user = User.find_by(username: params[:id])
  end

  def update
    @user = User.find_by(username: params[:id])

    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    user = User.find_by(username: params[:id])

    name = user.name
    user.destroy

    flash[:success] = "Account for #{name} deleted."
    redirect_to users_url
  end

  def show
    user = User.find_by(username: params[:id])

    if user.present?
      return render :show, locals: { user: user }
    end

    result = FetchTweets.call(username: params[:id])

    if result.user.present?
      user = result.user
      render :show, locals: { user: user }
    else
      redirect_to root_url
    end
  end

  def feed
    user = User.find_by(username: params[:id])
    squawks = user.squawks.paginate(page: params[:page])
    render :feed, locals: { feed_items: squawks }, layout: false
  end

  def following
    @user = User.find_by(username: params[:id])
    @title = "Following"
    @users = @user.followed_users.paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @user = User.find_by(username: params[:id])
    @title = "Followers"
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end

  private

  def user_params
    params
      .require(:user)
      .permit(:name, :username, :email, :password, :password_confirmation)
  end

  def correct_user
    user = User.find_by(username: params[:id])
    redirect_to(root_url) unless current_user?(user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
