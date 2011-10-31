class SwapsController < ApplicationController
  skip_before_filter :do_breadcrumbs
  before_filter :require_user
  resources_controller_for :swaps
  before_filter :do_breadcrumbs
  before_filter :fetch_swappable_items, :only => [:edit, :update]
  before_filter :can_withdraw, :only => [:destroy]
  

  helper_method :them

  def new
    @swap = Swap.new

    if current_user.id == params[:user_id].to_i
      redirect_to :back
      return
    end

    @swap.swap_parties.build(:user_id => current_user, :response => 1)
    @swap.swap_parties.build(:user_id => params[:user_id], :response => 0)
    @swap.name ||= "Offer between #{current_user} and #{them}"

    fetch_swappable_items

    if params[:item] and @their_swappable_items.include?(Item.find(params[:item]))
      @swap.swap_items.build(:item => Item.find(params[:item]), :recipient => current_user)
    end
  end

  def create
    @swap = Swap.new(params[:swap])

    @swap = update_swap_items(@swap)

    me = @swap.swap_parties.build(:user => current_user, :shipping_address => current_user.shipping_address.clone, :response => 1)
    me.cash_offer = params[:cash_offer]
    @swap.swap_parties.build(:user => them, :shipping_address => them.shipping_address.clone, :response => 0)
    @swap.expiration = DateTime.now + 14.days

    if @swap.save
      redirect_to user_swaps_path(current_user)
    else
      @cash_offer = params[:cash_offer]
      fetch_swappable_items
      render :new
    end
  end

  def edit
    @swap = find_resource

    if @swap.expired? or @swap.agreed
      redirect_to user_swap_path(current_user, swap)
    else
      @cash_offer = @swap.swap_parties.where(:user_id => current_user.id).first.cash_offer || ""
      fetch_swappable_items
    end
  end

  def update
    @swap = find_resource

    if params[:cash_offer]
      @swap.swap_parties.where(:user_id => current_user.id).cash_offer = params[:cash_offer]
    end

    if @swap.update_attributes(params[:swap]) and @swap.save
      @swap = update_swap_items(@swap)
      redirect_to user_swaps_path(current_user)
    else
      @cash_offer = params[:cash_offer]
      fetch_swappable_items
    end
  end

  def accept
    @swap = find_resource
    @cash_offer = @swap.swap_parties.first.cash_offer || ""
    if @swap.is_cash_offer? && current_user.paypal_email.blank?
    	 flash[:notice] = "You dont have a paypal email set and need to set it to accept this offer"
      redirect_to edit_user_path(current_user)
    else
	    party = my_party
	    party.response = 1 if party.response == 0
	    party.save!
	    redirect_to user_swaps_path(current_user)
    end
  end

  def decline
    @swap = find_resource
    party = my_party
    party.response = 2 if party.response == 0
    party.save!
    redirect_to user_swaps_path(current_user)
  end
  
  def confirm
    @swap = find_resource
    #redirect_to swap_path(swap) unless swap.accepted and !swap.completed
   
    if request.post? and !params['confirmed'].nil?
      @party = my_party
      @party.confirmed = (params['confirmed'])
      @party.confirm_notes = params['notes']
      @party.save
    end
  end

  def extend
    @swap = find_resource
    
    extension = params[:days].to_i || 1
    @swap.expiration += extension.days

    @swap.save!

    redirect_to user_swap_path(current_user, @swap)
  end

  def checkout
    @swap = find_resource
    party = my_party
    @amt  = party.cash_offer || 0

    redirect_to user_swap_path(current_user, @swap) and return if @amt == 0

    @shipping_address = party.shipping_address || party.build_shipping_address

    @shipping_address.update_attributes(params[:shipping_address]) if request.post?

    #if request.post? and (@shipping_address.save || @shipping_address.valid?)
    if (@shipping_address.save || @shipping_address.valid?)
      # let's do this!

      gw = AdaptivePaymentGateway.new
      tracking_id = Digest::SHA1.hexdigest("--howboutit--#{@swap.id}--#{DateTime.now.to_s}")
      
      shipping_amount =0
       @swap.swap_items.each do |si|
         shipping_amount += si.item.price
       end
      
      
      response = gw.pay(:to_user => their_party.user, :from_user => party.user,
        :return_url => thanks_offer_url(@swap),
        :cancel_url => user_swaps_url(current_user),
        :amount => party.cash_offer+shipping_amount,
        :tracking_id => tracking_id)

      if response.is_error? or response.pay_key.blank?
        # got an error from paypal, do... something
        if response.error_id == '569042'
          @paypal_error = "The receiving party must verify their paypal account before the swap can proceed"
        else
          @paypal_error = response.error_message
        end
        
      else
        # got a paykey, create Payment then bounce user to paypal and get them to cough up some dough

        Payment.create!(:swap_id => @swap.id, :user_id => party.user.id,
          :recipient_id => their_party.user.id, 
          :paypal_correlation_id => response.correlation_id,
          :paypal_pay_key => response.pay_key,
          :paypal_payment_status => response.payment_exec_status,
          :paypal_tracking_id => tracking_id,
          :amt => party.cash_offer, :fee_amt => gw.fee, :successful => false )
        
        redirect_to AdaptivePaymentGateway.redir_url(response).to_s
      end
    end    
  end

  def thanks
    
  end

  private
  
  def can_withdraw
    @swap = find_resource
    redirect_to user_swap_path(current_user, @swap) if !@swap.can_withdraw?
  end

  def pretty_name

    name = "Offer"

    if !enclosing_resource.nil? and enclosing_resource == current_user
      name = "Your Offers"
    end
    
    if params[:action] == 'new'
      name = "New Offer"
    end

    if params[:action] == 'show' && find_resource
      name = find_resource.name
    end

    name
  end

  def update_swap_items(swap)
    # remove unselected items
    swap.swap_items.each do |si|
      si.destroy if !(params[:their_items] + params[:my_items]).include?(si.item.id.to_s)
    end

    # add their items

    unless params[:their_items].nil?
      params[:their_items].each do |i|
        item = Item.find(i)
        if item.available
          swap.swap_items.build(:item => item, :recipient => current_user)
        end
      end
    end

    # add my items
    
    unless params[:my_items].nil?
      params[:my_items].each do |i|
        item = Item.find(i)
        if item.available
          swap.swap_items.build(:item => item, :recipient => them)
        end
      end
    end

    swap

  end

  def my_party
    @swap.swap_parties.where(:user_id => current_user.id).first
  end

  def their_party
    # only works for two party swaps, obviously
    @swap.swap_parties.where(:user_id.ne => current_user.id).first
  end

  def them
    User.find(params[:user_id])
  end

  def fetch_swappable_items
    @my_swappable_items = current_user.items.available
    @their_swappable_items = them.items.available
  end

  def find_resource(id = params[:id])
    swap = Swap.joins(:swap_parties).
      where(:swap_parties => {:user_id => current_user.id}, :id => id).
      find(:first, :readonly => false)

    raise ActiveRecord::RecordNotFound if swap.nil?

    swap
  end

  def find_resources
    Swap.joins(:swap_parties).where(:swap_parties => {:user_id => current_user.id}).
      order('completed ASC, expiration ASC').
      page(params[:page]).per(15)
  end

end
