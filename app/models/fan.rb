class Fan < ActiveRecord::Base
  belongs_to :fannable, :polymorphic => true

  validates :user,  :uniqueness => {:scope => [:fannable_type, :fannable_id]}
end
