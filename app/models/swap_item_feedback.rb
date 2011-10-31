class SwapItemFeedback < ActiveRecord::Base
  belongs_to :swap_item
  belongs_to :user

  validates :rating, :numericality => {:integer_only => true, :allow_nil => false}
  validates :user, :presence => true
  validates :swap_item, :presence => true
  
end
