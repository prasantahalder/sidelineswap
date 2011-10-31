class PaymentObserver < ActiveRecord::Observer
  def after_save(payment)
    if payment.successful
      recipient_party  	= payment.swap.swap_parties.where(:user_id => payment.recipient_id).first
      payor_party  	= payment.swap.swap_parties.where(:user_id => payment.user_id).first	
      SwapMailer.paid(recipient_party, payor_party).deliver
    end
  end
end
