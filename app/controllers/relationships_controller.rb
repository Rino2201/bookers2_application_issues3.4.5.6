class RelationshipsController < ApplicationController
before_action :authenticate_user!
# サンプルコード参照

  #フォローする時
  def create
    user = User.find(params[:user_id])
    current_user.follow(user)
    # ↑ サンプルコード参照
    # current_user.follow(params[:user_id])
    redirect_to request.referer
  end

  #フォロー外す時
  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user)
    # ↑ サンプルコード参照
    # current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  #フォロー一覧
  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end

  #フォロワー一覧
  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end

end
