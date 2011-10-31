class SwapItem < ActiveRecord::Base
  attr_readonly [:item_id, :swap_id]
  belongs_to :recipient, :class_name => 'User', :readonly => true
  belongs_to :item
  belongs_to :swap, :readonly => true

  #validates :quantity,      :numericality => {:greater_than_or_equal_to => 1,
  #  :integer_only => true, :allow_nil => false}

  validates :item_id, :uniqueness => {:scope => :swap_id}

  def validate
    if self.swap && self.swap.expired?
      self.errors[:base] << "Swap has expired"
    end

    if  self.swap && self.swap.agreed
      self.errors[:base] << "Can't change items once swap has been agreed upon"
    end

    unless self.item.available
      self.errors[:item] << "Item is not available"
    end
  end

end
