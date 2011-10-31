require 'pp'

class Payment < ActiveRecord::Base
  belongs_to :swap
  belongs_to :user
  belongs_to :receipient, :class_name => 'User'

  scope :successful, where(:successful => true)

  def notify
    log = Logger.new(File.open(IPN_LOG, 'a'))

    log.info("---\n" + DateTime.now.to_s)
    log.info(pp(params))

    @payment = find_resource

    if !@payment
      log.error("Payment '#{params['id']}' not found")
      render :text => 'PAYMENT NOT FOUND', :status => 404
    end

    @payment.paypal_txn_id = params['ixn_id']
    @payment.paypal_payment_status = params['payment_status']
    log.info("Updated payment #{@payment.id}.")
    log.info("Updated payment #{@payment.id}.")

    if @payment.save
      log.info("Updated payment #{@payment.id}.")
    end

  end


end
