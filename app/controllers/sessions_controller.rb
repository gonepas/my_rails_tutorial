class SessionsController < ApplicationController
  def new; end

  def create
    session = params[:session]
    user = User.find_by email: session[:email].downcase
    if user && user.authenticate(session[:password])
      if user.activated?
        login_success user
      else
        not_active
      end
    else
      login_fail
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def login_success user
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    redirect_back_or user
  end

  def not_active
    message = t "mail.not_activated_pls_check"
    flash[:warning] = message
    redirect_to root_url
  end

  def login_fail
    flash[:danger] = t "session.login_fail"
    render :new
  end
end
