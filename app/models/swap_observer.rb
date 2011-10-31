class SwapObserver < ActiveRecord::Observer
  def after_save(swap)
    if swap.agreed_changed? && swap.agreed

      # Notify parties that swap was agreed
      #swap.swap_parties.each do |party|
       # SwapMailer.agreed(party).deliver
      #end
      
      SwapPartyMailer.offeraccepted(swap.swap_parties.first, swap.swap_parties.last)
      if swap.is_cash_offer?
        SwapPartyMailer.acceptedoffer_cash(swap.swap_parties.last, swap.swap_parties.first)
      else
        SwapPartyMailer.acceptedoffer(swap.swap_parties.last, swap.swap_parties.first)
	  end
	  
      # Mark items as now unavailable
      swap.items.each do |item|
        item.available = false
        item.save!

        item.swaps.each do |s|
          s.remove_unavailable_items! if s != swap
        end
      end
    end
  end
  def after_create(swap)
  #actually this should probably go on teh swap party obsever but oh well
    SwapMailer.newoffer(swap.swap_parties.last, swap).deliver
  end
end
