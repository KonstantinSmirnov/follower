class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  require 'securerandom'

  def new
  end

  def create
    @user = User.new(user_params)

    password = SecureRandom.urlsafe_base64(6)
    @user.password = password
    @user.password_confirmation = password

    respond_to do |format|
      if @user.save
        # redirect_to root_path, notice: 'Success'
        format.js { render 'create'}
      else
        format.js { render 'show_registration_errors' }
      end
    end
  end

  def activate
    if (@user = User.load_from_activation_token(params[:id]))
      @user.activate!
      reset_password_token = SecureRandom.urlsafe_base64(16)
      @user.reset_password_token = reset_password_token
      @user.save
      redirect_to(edit_password_reset_path(@user.reset_password_token), :notice => 'User was successfully activated. Now please select a password.')
    else
      redirect_to(login_path, :notice => 'Activation token is invalid.')
    end
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end
