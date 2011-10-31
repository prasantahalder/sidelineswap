class SwapMailer < ActionMailer::Base
  default :from => "updates@sidelineswap.com"

  def agreed(party)
    @swap = party.swap
    @subject = "Your swap has been agreed on!"
    @swap_url = user_swap_url(party.user, @swap)
    
    mail :to => party.user.email, :subject => @subject
  end

  def paid(recipient_party, payor_party)
    @swap = recipient_party.swap
    @shipping_address = payor_party.shipping_address
    @subject = "#{payor_party.user.login} has paid"
    @swap_url = user_swap_url(recipient_party.user, @swap)
    
    @payor = recipient_party.user

    mail :to => recipient_party.user.email, :subject => @subject
  end

  def removed_items(items, party)
    @swap = party.swap
    @subject = "Items have been removed from your swap."
    @swap_url = user_swap_url(party.user, @swap)
    @items = items

    mail :to => party.user.email, :subject => @subject
  end
  def newoffer(party, swap)
    @swap = party.swap
    @swap_url = user_swap_url(party.user, @swap)
    @party = party
     @swaps_url = user_swaps_url(party.user)
    mail :to => party.user.email, :subject => "You received an offer on SidelineSwap.com!"
  end
end
