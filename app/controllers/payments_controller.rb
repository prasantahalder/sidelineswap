require 'pp'
class PaymentsController < ApplicationController

  include ActiveMerchant::Billing::Integrations
  resources_controller_for :payments
  
  skip_before_filter :verify_authenticity_token, :only => :notify

  def notify
    logfile = Rails.root.join("log", "ipn.log")
    mylogger = Logger.new(logfile)

    mylogger.info('Received IPN response' + DateTime.now.to_s)
    mylogger.debug(request.raw_post.pretty_inspect)    
    
    status = params['status']
    tracking_id = params['tracking_id']
    pay_key = params['pay_key']    

    p = Payment.where(:paypal_pay_key => pay_key,
      :paypal_tracking_id => tracking_id).first


    if p.blank?
      mylogger.error("Could not find Payment for IPN message!")
      render :text => 'NG', :status => 404 
      return
    end

    p.successful = (status == 'COMPLETED')
    p.save!

    render :text => 'OK'
  end

end
