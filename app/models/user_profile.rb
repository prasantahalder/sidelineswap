class UserProfile < ActiveRecord::Base
  attr_readonly :user_id
  belongs_to :user
  has_and_belongs_to_many :teams
  has_many :images, :as => :attachable
  accepts_nested_attributes_for :images, :allow_destroy => true, :reject_if => :all_blank
  belongs_to :store

  def age
    return nil if birth_date.nil?
    now = Time.now.utc.to_date
    now.year - birth_date.year - (birth_date.to_date.change(:year => now.year) > now ? 1 : 0)
  end


  validate      :gender,  :inclusion => {:in => %w( M F ), :allow_nil => true}
end
