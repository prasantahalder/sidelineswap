class SwapPartyMailer < ActionMailer::Base
  default :from => "updates@sidelineswap.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.swap_party_mailer.declined.subject
  #
  def response(respondent, party)
    @subject = 'Update to your swap'
    @swap = party.swap
    @party = party
    @respondent = respondent
    @swaps_url = user_swaps_url(party.user)

    @response = case respondent.response
    when 0 then "has not responded"
    when 1 then "Accepted"
    when 2 then "Declined"
    end

    mail :to => party.user.email, :subject => @subject
  end
  def declined(respondent, party)
    @subject = 'Your swap offer was rejected'
    @swap = party.swap
    @party = party
    @respondent = respondent
    @swaps_url = user_swaps_url(party.user)
    @their_locker = user_lockers_url(respondent.user)
    @my_locker = user_lockers_url(party.user)

    @response = case respondent.response
    when 0 then "has not responded"
    when 1 then "Accepted"
    when 2 then "Declined"
    end

    mail :to => party.user.email, :subject => @subject
  end
  def expired(respondent,party)
    @subject = 'Sorry, Your Offer Expired'
    @swap = party.swap
    @party = party
    @respondent = respondent
    @swaps_url = user_swaps_url(party.user)
    @their_locker = user_lockers_url(respondent.user)
    @my_locker = user_lockers_url(party.user)
    
    mail :to => party.user.email, :subject => @subject
  end
  def offeraccepted(respondent,party)
    @subject = 'Congratulations! Your offer has been accepted! Time to ship your gear'
    @swap = party.swap
    @party = party
    @respondent = respondent
    @swaps_url = user_swaps_url(party.user)
    @their_locker = user_lockers_url(respondent.user)
    @my_locker = user_lockers_url(party.user)
    @shipping_address = respondent.shipping_address
    
    mail :to => party.user.email, :subject => @subject
  end
  def acceptedoffer(respondent,party)
    @subject = ' Nice Work! You have agreed to Swap! Time to ship your gear'
    @swap = party.swap
    @party = party
    @respondent = respondent
    @swaps_url = user_swaps_url(party.user)
    @their_locker = user_lockers_url(respondent.user)
    @my_locker = user_lockers_url(party.user)
    @shipping_address = respondent.shipping_address
    
    mail :to => party.user.email, :subject => @subject
  end
  def acceptedoffer_cash(respondent,party)
    @subject = 'Nice Work! You accepted #{respondant.user}\'s offer. You\'ll get paid shortly'
    @swap = party.swap
    @party = party
    @respondent = respondent
    @swaps_url = user_swaps_url(party.user)
    @their_locker = user_lockers_url(respondent.user)
    @my_locker = user_lockers_url(party.user)
    @shipping_address = respondent.shipping_address
    
    mail :to => party.user.email, :subject => @subject
  end
  def nopaycancel(respondent,party)
     @subject = 'the swap was cancelled because the party failed to pay'
    @swap = party.swap
    @party = party
    @respondent = respondent
    @swaps_url = user_swaps_url(party.user)
    @their_locker = user_lockers_url(respondent.user)
    @my_locker = user_lockers_url(party.user)
    
    mail :to => party.user.email, :subject => @subject
  end
end
