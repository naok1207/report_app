class RelationshipsController < ApplicationController
  
    def create            # follow する
      user = User.find(params[:follow_id])
      following = current_user.follow(user)
      if following.save   # follow 成功
        # flash[:success] = 'ユーザーをフォローしました'
        redirect_to user
      else                # follow 失敗
        # flash.now[:alert] = 'ユーザーのフォローに失敗しました'
        redirect_to user
      end
    end
  
    def destroy           # unfollow する
      user = User.find(params[:follow_id])
      following = current_user.unfollow(user)
      if following.destroy  # unfollow 成功
        redirect_to user
      else                  # unfollow 失敗
        redirect_to user
      end
    end

    def followed          # follow 先の user一覧を取得
      @followed = Relationship.where(user_id: params[:id])
      id = []
      @followed.each do |followed|
        id << followed.follow_id
      end
      @users = User.find(id)
    end

    def follower          # follower のユーザー一覧を取得
      @user = User.find(params[:id])
      @follower = Relationship.where(follow_id: @user.id)
      id = []
      @follower.each do |follower|
        id << follower.user_id
      end
      @users = User.find(id)
    end
  end