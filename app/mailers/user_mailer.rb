class UserMailer < ApplicationMailer
  def activation_needed_email(user)
    @user = user
    @url  = activate_user_url(user.activation_token, host: default_url_options[:host])
    mail(:to => user.email,
         :subject => "Account confirmation")
  end

  def activation_success_email(user)
    @user = user
    #@url  = login_url(host: default_url_options[:host])
    @url = root_url(host: default_url_options[:host])
    mail(:to => user.email,
         :subject => "Your account is now activated")
  end
end
