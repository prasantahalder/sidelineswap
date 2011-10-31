class SwapComment < ActiveRecord::Base
  belongs_to :swap
  belongs_to :user

  validates :comment, :presence => true
end
