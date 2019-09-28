class RelationshipsController < ApplicationController
  
    def create
      user = User.find(params[:follow_id])
      following = current_user.follow(user)
      if following.save
        flash[:success] = 'ユーザーをフォローしました'
        redirect_to user
      else
        flash.now[:alert] = 'ユーザーのフォローに失敗しました'
        redirect_to user
      end
    end
  
    def destroy
      user = User.find(params[:follow_id])
      following = current_user.unfollow(user)
      if following.destroy
        redirect_to user
      else
        redirect_to user
      end
    end

    def followed
      @followed = Relationship.where(user_id: params[:id])
      id = []
      @followed.each do |followed|
        id << followed.follow_id
      end
      @users = User.find(id)
    end

    def follower
      @user = User.find(params[:id])
      @follower = Relationship.where(follow_id: @user.id)
      id = []
      @follower.each do |follower|
        id << follower.user_id
      end
      @users = User.find(id)
    end
  
    private
  
  
  end