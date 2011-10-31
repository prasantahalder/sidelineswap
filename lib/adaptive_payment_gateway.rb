require 'pp'
require 'adaptive_payment_response'

class AdaptivePaymentGateway
  cattr_reader :test_endpoint
  cattr_reader :live_endpoint
  cattr_reader :test_redir
  cattr_reader :live_redir
  
  cattr_accessor :fee_recipient
  cattr_accessor :fee_pct
  cattr_accessor :fee_amt

  cattr_accessor :login
  cattr_accessor :password
  cattr_accessor :signature
  cattr_accessor :app_id
  cattr_accessor :ipn_url

  attr_reader :fee

  @@test_endpoint = 'https://svcs.sandbox.paypal.com/AdaptivePayments/'
  @@live_endpoint = 'https://svcs.paypal.com/AdaptivePayments/'
  @@test_redir    = 'https://www.sandbox.paypal.com/webscr?cmd=_ap-payment&paykey='
  @@live_redir    = 'https://www.paypal.com/webscr?cmd=_ap-payment&paykey='

  @@test = false
  @@fee_pct = 7
  @@fee_amt = 0
  @@debug = true



  def endpoint
    url = (@@test) ? @@test_endpoint : @@live_endpoint

    URI.parse(url)
  end

  def self.redir
    url = (@@test) ? @@test_redir : @@live_redir

    URI.parse(url)
  end

  def pay(params)
    #from_user   = params[:from_user]
    to_user     = params[:to_user]
    amt         = params[:amount].to_f # in decimal
    return_url  = params[:return_url]
    cancel_url  = params[:cancel_url] || return_url
    tracking_id	= params[:tracking_id]
    
    raise ArgumentError.new(":tracking_id must be specified") if tracking_id.blank?
    raise ArgumentError.new(":return_url must be specified") if return_url.blank?

    raise ArgumentError.new("amount must be greater than 0") if amt <= 0

    _fee_recipient = params[:fee_recipient] || @@fee_recipient
    _fee_amt       = params[:fee_amt] || @@fee_amt
    _fee_pct       = params[:fee_amt] || @@fee_pct

    @fee = _fee_amt + ((_fee_pct.to_f/100) * amt)
    @fee = ((fee*100).round).to_f * 0.01
    remainder = amt - @fee

    receiver_list =
      {'receiver' =>[
        {'email' => _fee_recipient, 'primary' => 'true', 'amount' => amt},
        {'email' => to_user.paypal_email, 'primary' => 'false', 'amount' => remainder}]}
    

    request = {
      'returnUrl' => return_url,
      'cancelUrl' => cancel_url,
      'requestEnvelope' => {'errorLanguage' => 'en_US'},
      'currencyCode' => 'USD',
      'receiverList' => receiver_list,
      'actionType' => 'PAY',
      'feesPayer' => 'SECONDARYONLY',
      'ipnNotificationUrl' => ipn_url,
      'trackingId' => tracking_id
    }
    
    response = send_request('Pay', request.to_json)

    AdaptivePaymentResponse.new(response)
  end

  def get_status(params)
    request = {
      'requestEnvelope' => {'errorLanguage' => 'en_US'},
    }

    request['payKey'] = params[:pay_key] unless params[:pay_key].blank?
    request['transactionId'] = params[:transaction_id] unless params[:transaction_id].blank?
    send_request('PaymentDetailsRequest', request.to_json)
  end

  def self.test?
    @@test
  end

  def self.test=(test)
    @@test = (test)
  end

  def self.debug?
    @@debug
  end

  def self.debug=(debug)
    @@debug = (debug)
  end

  def self.redir_url(response)
    return nil if response.blank?
    url = self.redir
    url.query += response.pay_key
    url
  end

  private

  def log(message)
    logfile = Rails.root.join("log", "adaptive_payment.log")
    @logger ||= Logger.new(File.open(logfile, 'a'))

    @logger.info("---\n" + DateTime.now.to_s)
    @logger.info(message)

    puts message
  end

  def send_request(action, request_body)
    url = self.endpoint + action

    headers = {
      "X-PAYPAL-REQUEST-DATA-FORMAT" => "JSON",
      "X-PAYPAL-RESPONSE-DATA-FORMAT" => "JSON",
      "X-PAYPAL-SECURITY-USERID" => self.login,
      "X-PAYPAL-SECURITY-PASSWORD" => self.password,
      "X-PAYPAL-SECURITY-SIGNATURE" => self.signature,
      "X-PAYPAL-APPLICATION-ID" => self.app_id
    }

    debug_msg = "Request URL: \n\n #{url} \n"
    debug_msg += "Request Headers: \n\n #{headers.pretty_inspect} \n"
    debug_msg += "Request Body: \n\n #{request_body} \n"

    if @@debug
      log(debug_msg)
    end

    request = Net::HTTP::Post.new(url.path)
    request.body = request_body
    headers.each_pair { |k,v| request[k] = v }
    request.content_type = 'text/json'
    server = Net::HTTP.new(url.host, 443)
    server.use_ssl = true
    response = server.start { |http| http.request(request) }.body
    response = ActiveSupport::JSON.decode(response)

    if @@debug
      log("Response Body: " + response.pretty_inspect )
    elsif is_response_error?(response)
      log("ERROR\n\n" + debug_msg + "Response Body: \n\n" + response.pretty_inspect)
    end

    response
  end
  
  def is_response_error?(response)
    response['ack'] == 'Failure'
  end
end
