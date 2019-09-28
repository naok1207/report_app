class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]

  def index
    @user = User.find(current_user.id)
    @users = User.where(activated: true)
    @post = Post.new
  end

  def show
    @user = User.find(params[:id])
    @post = Post.new
    @posts = Post.where(user_id: @user.id).order(created_at: "DESC")
    @followers = Relationship.where(follow_id: @user.id)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      Profile.create!(user_id: @user.id)
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "変更成功"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def logged_in_user
      unless logged_in?
        redirect_to login_url
      end
    end
end
