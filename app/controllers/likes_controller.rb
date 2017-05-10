# frozen_string_literal: true

class LikesController < ApplicationController
  def index
    if (user = User.find(params[:user_id]))
      render json: user.likes
    elsif (squawk = Squawk.find(params[:squawk_id]))
      render json: squawk.likes
    else
      head :unprocessable_entity
    end
  end

  def create
    like = Like.new(squawk_id: params[:squawk_id], liker: current_user)

    if like.save
      head :ok
    else
      render json: { errors: like.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    like = Like.find_by(squawk_id: params[:squawk_id], liker: current_user)

    if like.try(:destroy)
      head :ok
    else
      head :unprocessable_entity
    end
  end
end
