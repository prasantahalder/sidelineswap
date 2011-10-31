class Category < ActiveRecord::Base
  has_ancestry
  has_many :items

  validates :name,        :presence => true,
    :uniqueness => {:scope => :ancestry}

  def to_s
    name
  end
end
