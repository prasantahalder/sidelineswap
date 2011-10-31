class Store < ActiveRecord::Base
  belongs_to :user
  has_many :items
  has_one :user_profile
  belongs_to :address
  
end
