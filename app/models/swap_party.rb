class SwapParty < ActiveRecord::Base
  RESPONSES = [['No Response', 0], ['Accepted',1], ['Declined', 2]]

  before_save :set_responded_at
  before_create :set_shipping_address
  
  attr_readonly [:swap_id, :user_id]
  attr_protected [:response, :shipping_address_id, :responded_at]
  belongs_to :user, :readonly => true
  belongs_to :swap
  belongs_to :shipping_address, :class_name => 'Address'

  validates :response, :inclusion => {:in => 0..2}
  #validates :ship_address, :presence => true
  #validates :swap, :presence => true
  #validates :user, :presence => true

  scope :with_cash_offer, where(:cash_offer.gt => 0)

  accepts_nested_attributes_for :shipping_address

  def response_human
    return nil if self.response.nil?
    RESPONSES.select{|r| r[1] == self.response}.first[0]
  end

  def validate
    if self.swap && self.swap.expired?
      self.errors[:base] << "Swap has expired"
    end

    if  self.response_changed? && self.swap && self.swap.agreed
      self.errors[:response] << "Can't change response once swap has been agreed upon"
    end

    if self.response_changed? && self.response == 1 && self.shipping_address.nil?
      self.errors[:shipping_address] << "Please include a shipping address"
    end
  end

  def swap_items
    self.swap.items.where(:user_id => self.user_id)
  end

  private

  def set_shipping_address
    if !self.user.shipping_address.nil? && self.shipping_address.nil?
      self.shipping_address = self.user.shipping_address
    end
  end

  def set_responded_at
    if self.response_changed? or (self.new_record? and self.response > 0)
      self.responded_at = DateTime.now
    end
  end

end
