class PasswordResetsController < ApplicationController
  skip_before_filter :require_login

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_email(params[:user][:email])
    if !@user.blank?
      @user.reset_password_token = nil
      @user.reset_password_token_expires_at = nil
      @user.reset_password_email_sent_at = nil
      @user.save
    end
    @user.deliver_reset_password_instructions! if @user
    redirect_to(login_path, notice: 'Instructions have been sent to your email.')
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    if @user.blank?
      redirect_to login_path, alert: 'Invalid token'
    end
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    if @user.blank?
      redirect_to login_path, alert: 'Invalid token'
    end

    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    @user.reset_password_token = nil
    @user.reset_password_token_expires_at = nil
    @user.reset_password_email_sent_at = nil

    if @user.save && !params[:user][:password].empty?
      redirect_to(login_path, notice: 'Password was successfully updated.')
    else
      flash.now[:notice] = 'Your new password is invalid'
      render action: :edit
    end
  end
end
