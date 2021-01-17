class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit,:update, :destroy]
  before_action :require_same_user, only: [:edit, :update, :destroy]

  def new
    @user = User.new
  end

  def show
    @posts = @user.posts.paginate(page: params[:page], per_page: 5).includes(:photos, :user).order('created_at DESC')
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "アップデートしました"
      redirect_to posts_path
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "ようこそWater Bird Clubへ、 #{@user.username} さん！"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def destroy
    @user.destroy
    session[:user_id] = nil
    flash[:notice] = "アカウントを削除しました"
    redirect_to root_path
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user != @user && !current_user.admin?
      flash[:alert] = "他の人のアカウントは編集できません"
      redirect_to @user
    end
  end

end
