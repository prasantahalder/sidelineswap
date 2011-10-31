class Swap < ActiveRecord::Base
  has_many :swap_items, :dependent => :destroy
  has_many :items, :through => :swap_items
  has_many :swap_parties, :dependent => :destroy
  has_many :users, :through => :swap_parties
  has_many :swap_comments
  has_many :payments

  accepts_nested_attributes_for :swap_items, :allow_destroy => true
  attr_protected [:agreed, :completed]

  scope :not_expired, where('expiration > NOW()')
  scope :expired, where('expiration < NOW()')
  scope :recent_completed, where('completed = 1 AND updated_at > DATE_SUB(NOW(), 1 WEEK)')
  scope :not_completed, where('completed = 0')  
  scope :right_col_completed, where({:completed => nil} | {:completed => true, :updated_at.gt => 1.week.ago})
  scope :right_col, right_col_completed.not_expired.order('updated_at DESC, created_at DESC').limit(3)

  #accepts_nested_attributes_for :swap_parties

  validate :validate_expiry
  validate :validate_agreement
  validate :validate_parties
  validate :validate_items
  
  def other_party(user)
    self.users.where(:id ^ user.id).first
  end

  def validate_expiry
    self.errors[:base] << "Swap has expired" if self.expired?
  end

  def validate_agreement
    self.errors[:base] << "Swap has been agreed and cannot be changed" if self.agreed && !self.agreed_changed? && !self.completed_changed?
  end

  def validate_parties
    self.errors[:base] << "Please add two parties" if self.swap_parties.length < 2
  end

  def validate_items
    if self.swap_items.length < 1 or
        (self.swap_items.collect{|si| si.recipient_id}.uniq.length < 2) and

        self.swap_parties.any?{|s_p| self.swap_items.select{|si| si.item.user == s_p.user}.empty? and s_p.cash_offer == 0}
      self.errors[:base] << "Please add more items or cash to swap"
    end

    self.swap_items.each do |si|
      si.errors[:recipient] << "Recipient is not party to swaps" if self.users.none?{|u| u == si.recipient}
      si.errors[:item] << "Item is no longer available" unless si.item.available
    end
  end
  
  def expired?
    !self.agreed && self.expiration < DateTime.now
  end

  def can_update?
    !self.expired? && !self.agreed && self.swap_parties.any?{|s| s.response == 0}
  end
  
  def can_withdraw?
    !self.agreed && self.swap_parties.any?{|s| s.response == 0}
  end
  
  def was_rejected?
  	self.swap_parties.any?{|s| s.response == 2}
  end
  
  def can_complete?
    self.agreed && !self.completed
  end

  def can_pay?(user)
    (self.swap_parties.where(:user_id => user.id).with_cash_offer.count > 0) &&
      self.payments.successful.count == 0 && self.agreed
  end
  
  def is_cash_offer?
    self.swap_parties.any?{|s| s.cash_offer.to_f > 0}
  end
  
  def paid?
  	self.payments.successful.count > 0
  end

  def remove_unavailable_items!
    return if self.agreed

    removed_items = []

    self.swap_items.each do |si|
      unless si.item.available
        removed_items << si.item
        si.destroy
      end
    end

    unless removed_items.blank? or self.expired?
      self.swap_parties.each do |party|
        party.response = 0
        party.save!
        SwapMailer.removed_items(removed_items, party).deliver
      end
    end
  end

end
