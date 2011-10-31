class Locker < ActiveRecord::Base
  belongs_to :user
  has_many :items
  has_many :fans, :as => :fannable, :dependent => :destroy

  validates :user, :presence => true
  validates :name, :presence => true

  def to_s
    name
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

  def items_remaining
    self.max_items - self.items.count
  end
end
