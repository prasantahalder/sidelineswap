class SwapPartyObserver < ActiveRecord::Observer
  def after_save(party)

    # response got changed by user and not just reset
    if party.response_changed? && party.response > 0 
      swap = party.swap

      # Update agreed status
      unless party.swap.agreed || swap.swap_parties.length < 2
        swap.agreed = swap.swap_parties.all?{|p| p.response == 1}
        swap.save!
        swap.swap_parties.select{|s_p| s_p != party}.each do |p|
#        swap.swap_parties.each do |p|
	@response = case party.response
    				when 0 then "has not responded"
    				when 1 then "Accepted"
    				when 2 then "Declined"
    			end
    	  case party.response
    	    when 2
    	      SwapPartyMailer.declined(party,p).deliver
    	    else  
              SwapPartyMailer.response(party, p).deliver
          end
        end
      else
      end
    end
  end
end
