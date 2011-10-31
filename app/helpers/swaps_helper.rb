module SwapsHelper
  def other_party(swap)
    swap.swap_parties.where(['user_id <> ?', current_user.id]).first
  end

  def current_party(swap)
    swap.swap_parties.where(['user_id = ?', current_user.id]).first
  end

  def delete_swap_item_tag
    hidden_field_tag '[swap][swap_items_attributes][__index__][_destroy]', "1"
  end

  def blank_swap_item
    render :partial => 'swap_item_blank'
  end

  def swap_has_item?(swap, item)
    swap.swap_items.any?{|si| si.item == item}
  end
end
