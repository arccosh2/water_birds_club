class PostsController < ApplicationController
  before_action :set_post, only: [:show, :destroy]
  before_action :require_same_user, only: [:destroy]
 
  def new
    @post = Post.new
    @post.photos.build
  end

  def create
    @post = Post.new(post_params)
    if @post.photos.present?
      @post.save
      redirect_to posts_path
      flash[:notice] = "投稿が保存されました"
    else
      redirect_to new_post_path
      flash[:alert] = "投稿に失敗しました"
    end
  end

  def show
   
  end

  def index
    @posts = Post.paginate(page: params[:page], per_page: 5).includes(:photos, :user).order('created_at DESC')
  end

  def destroy
    if @post.user == current_user
      flash[:notice] = "投稿が削除されました" if @post.destroy
    else
      flash[:alert] = "投稿の削除に失敗しました"
    end
    redirect_to posts_path
  end
  

  private
  def post_params
    params.require(:post).permit(:caption, photos_attributes: [:image]).merge(user_id: current_user.id)
  end

  def set_post
    @post = Post.find_by(id: params[:id])
  end

  def require_same_user
    if current_user != @post.user
      flash[:alert] = "他の人の投稿は編集できません"
      redirect_to @post
    end
  end
end
