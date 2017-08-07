class RelationshipsController < ApplicationController
  before_action :logged_in_user

  attr_reader :user

  def index
    @user = User.find_by id: params[:user_id]
    params[:is_following] ? following : followers
    render :index
  end

  def create
    active_relationships = current_user.active_relationships
    @user = User.find_by id: params[:followed_id]
    current_user.follow user
    @relationship = active_relationships.find_by followed_id: user.id
    respond
  end

  def destroy
    active_relationships = current_user.active_relationships
    @user = Relationship.find_by(id: params[:id]).followed
    current_user.unfollow user
    @relationship = active_relationships.build
    respond
  end

  private

  def respond
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def following
    @title = "Following"
    @users = @user.following.paginate page: params[:page]
  end

  def followers
    @title = "Followers"
    @users = @user.followers.paginate page: params[:page]
  end
end
