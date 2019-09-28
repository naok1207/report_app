class PostsController < ApplicationController
  before_action :set_user, only: [:index, :show, :new]

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_param)
    if @post.save
      flash[:success] = "作成成功"
      redirect_to user_path(id: current_user.id)
    end
  end

  def destroy
  end

  def show
    @post = Post.new
    @relations = Relationship.where(user_id: current_user.id)
    @follow = []
    @relations.each do |relation|
      @follow << relation.follow_id
    end
    @posts = Post.where(user_id: @follow).order(created_at: "DESC")
  end

  private
    def post_param
      params.require(:post).permit(:content)
    end

    def set_user
      @user = current_user
    end
end
