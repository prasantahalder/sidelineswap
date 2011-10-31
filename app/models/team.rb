class Team < ActiveRecord::Base
  has_and_belongs_to_many :user_profiles
  has_many :users, :through => :user_profiles
  has_many :items

  validates :name,      :presence => true,
    :uniqueness => {:scope => [:city, :state, :country]}
  validates :country,   :presence => true
end
