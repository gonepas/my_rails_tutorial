class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create show)
  before_action :find_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  attr_reader :user

  def index
    @users = User.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if user.save
      @user.send_activation_email
      flash[:info] = t "mail.check_noti"
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    @microposts = user.microposts.order_desc.paginate page: params[:page]
  end

  def edit; end

  def update
    if user.update_attributes user_params
      flash[:success] = t "user.updated"
      redirect_to user
    else
      render :edit
    end
  end

  def destroy
    user.destroy
    flash[:success] = t "user.delete"
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def find_user
    @user = User.find_by id: params[:id]

    return if user
    flash[:danger] = t "user.not_exist"
    redirect_to root_path
  end

  def correct_user
    redirect_to root_url unless @user.current_user? current_user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
