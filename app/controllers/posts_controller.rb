class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_param)
    if @post.save
      flash[:success] = "作成成功"
      redirect_to user_path(id: current_user.id)
    else
      render 'new'
    end
  end

  def destroy
  end

  private
    def post_param
      params.require(:post).permit(:content)
    end
end
