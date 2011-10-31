class Item < ActiveRecord::Base
  attr_readonly :user_id
  
  belongs_to :category
  belongs_to :user
  belongs_to :locker
  belongs_to :team
  has_many :swap_items
  has_many :swaps, :through => :swap_items
  has_many :images, :dependent => :destroy, :as => :attachable
  has_many :item_comments
  
  accepts_nested_attributes_for :images, :allow_destroy => true, :reject_if => :all_blank

  validates :name, :presence => true
  validates :user, :presence => true
  validates :category, :presence => true
  validates :price, :numericality => {:null => false}
  validates :description, :presence => true

  scope :available, where("available = 1 and swapped = 0")
  scope :popular, lambda { available.where(:last_hit.gte => 2.weeks.ago).order('items.hits DESC, items.last_hit DESC') }
  scope :popular_frontpage, available.order('items.hits DESC, items.last_hit DESC')
  scope :recent, lambda { available.where(:created_at.gte => 2.weeks.ago).order('items.created_at DESC') }
  scope :by_user, lambda {|user| where(:user_id => user.id)}
  scope :not_by_user, lambda {|user| where(:user_id ^ user.id)}

  validate_on_create :max_items

  def max_items
    if self.locker and self.locker.items.count >= self.locker.max_items
      errors[:base] << "You already have the maximum amount of items in your locker"
    end
  end

  def add_hit!
    class << self
      def record_timestamps; false; end
    end

    self.update_attributes(:hits => self.hits + 1, :last_hit => DateTime.now)

    class << self
      remove_method :record_timestamps
    end
  end

end
