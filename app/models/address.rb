class Address < ActiveRecord::Base

  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :street_1,  :presence => true
  validates :city,      :presence => true
  validates :state,     :presence => true, :inclusion => {:in => Carmen::state_codes('US')}
  validates :zip,       :presence => true, :format => {:with => %r{\d{5}(-\d{4})?}, :message => "should be 12345 or 12345-1234"}
  validates :phone,     :presence => true

  belongs_to :user
  has_one :store

end
