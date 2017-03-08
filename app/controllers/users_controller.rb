class UsersController < ApplicationController
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

  private

  def user_params
    params.require(:user).permit(:email)
  end
end
