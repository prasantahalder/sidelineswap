class UserMailer < ActionMailer::Base
  default :from => "team@0x7a69.net"
  
  def password_reset_email(user)
    @user = user
    @url = edit_password_reset_url(user.perishable_token)
    mail(:to => user.email, :subject => 'Password reset instructions')
  end
end
