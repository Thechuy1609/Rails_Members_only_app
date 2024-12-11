class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, except: :index

  def index
    @posts = Post.all
    @posts = Post.includes(:user).all
  end

  def new
    @post = Post.new
  end

  def update
    if @post.update(post_params)
      redirect_to posts_path, notice: 'Post was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end
  def destroy
    @post.destroy
    redirect_to posts_path, notice: 'Post was successfully deleted.'
  end
  def set_post
    @post = Post.find(params[:id])
    unless @post.user_id == current_user.id
      redirect_to posts_path, alert: 'You are not authorized to edit this post.'
    end
  end
  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = 'Post successfully created'
      redirect_to posts_path
    else
      flash.now[:error] = 'Something went wrong'
      render :new
    end
  end

    def edit
      @post = Post.find(params[:id])
    end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
