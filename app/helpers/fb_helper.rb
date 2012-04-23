# Helper methods defined here can be accessed in any controller or view in the application

Jp2.helpers do
  # def simple_helper_method
  #  ...
  # end
  def current_user
       #returns current user object need to rewrite once i learn the right way
    logger.debug "THIS IS SESSION #{session["_padrino_jp2_admin"].to_json}"
    user = Account.find_by_id(session["_padrino_jp2_admin"])
    logger.debug "This is current user object = #{@user.to_json}"
  	user
  end


  	
def get_fb_credits_modal(request)

    
  end

 def get_fb_paymodal_url(event)
  ##accepts and event object and returns a valid fb modal url
  uri = QueryParams.encode(event.fb_pay_request)

  url = 'https://www.facebook.com/dialog/pay?' + uri
  url
 end


end
