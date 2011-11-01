class Image < ActiveRecord::Base
  belongs_to :attachable, :polymorphic => true
  has_attached_file :photo,
    :styles => {
    :item_detail => "238x311#",
    :item_list => "138x152#",
    :item_featured => "158x103#",
    :thumb => "100x100#",
    :small => "300x300>",
    :large => "600x600>"
  }

  delegate :url, :to => :photo

  #validates_attachment_presence
end
