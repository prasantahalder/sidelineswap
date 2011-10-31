class AdaptivePaymentResponse
  attr_reader :ack, :correlation_id, :pay_key, :payment_exec_status,
    :error_id, :error_message, :raw
  
  def initialize(response)
    @raw = response
    r = response['responseEnvelope']

    raise ArgumentError.new("responseEnvelope not found, are you sure is this a paypal response?") if r.blank?

    @ack = r['ack']
    @correlation_id = r['correlationId']

    if @ack == 'Failure'
      @error_id = response['error'].first['errorId']
      @error_message = response['error'].first['message']
    end

    @pay_key = response['payKey']
    @payment_exec_status = response['paymentExecStatus']
  end

  def is_error?
    self.ack == 'Failure'
  end
end
