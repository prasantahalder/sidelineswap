class User < ActiveRecord::Base
  after_create :make_locker
  attr_accessible :password, :password_confirmation, :first_name, :last_name, :email, :shipping_address_id, :paypal_email, :login
  has_one :store
  acts_as_authentic do |c|
    #    c.crypto_provider = Authlogic::CryptoProviders::BCrypt
    c.merge_validates_uniqueness_of_email_field_options :message => 'seems to have been taken. Did you forget your password?'
    c.merge_validates_uniqueness_of_login_field_options :message => 'seems to have been taken. Did you forget your password?'
  end

  belongs_to :role
  belongs_to :billing_address, :class_name => 'Address'
  belongs_to :shipping_address, :class_name => 'Address'
  has_many :lockers
  has_many :items
  has_many :swap_parties
  has_many :swaps, :through => :swap_parties
  has_one :user_profile
  has_many :images, :through => :user_profile
  has_many :payments
  has_one  :address

  accepts_nested_attributes_for :shipping_address
  accepts_nested_attributes_for :billing_address

  #validates :shipping_address, :presence => true


  def to_s
    self.login
  end

  def full_name
    "#{first_name} #{last_name}"
  end
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserMailer.password_reset_email(self).deliver
  end

  private

  def make_locker
    Locker.create!(:name => "#{self.first_name}'s Locker", :user => self) if self.lockers.empty?
  end
end
