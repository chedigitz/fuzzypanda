Jp2.controllers :orders do
  # get :index, :map => "/foo/bar" do
  #   session[:foo] = "bar"
  #   render 'index'
  # end

  # get :sample, :map => "/sample/url", :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

  # get "/example" do
  #   "Hello world!"
  # end
  get :fb, :provides => :json do
    
    @oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_SECRET_KEY, 'https://purplepanda.heroku.com/fb/authenticate/')
    @signed_request = @oauth.parse_signed_request(params['signed_request'])
    logger.info "@signed_request = #{@signed_request.to_json}"
    logger.info "params passed in = #{params.to_json}"
    token = @signed_request['credits']['oauth_token'] 
    logger.info params["method"]
    method =  params["method"]
     buyer_id = params["buyer"]
    response = {}
    logger.info "method = #{method}"
    logger.info "buyer id = #{buyer_id}"
    if method == 'payments_get_items'
      
      #parse the oder info JSON fro FB
      order_info = JSON.parse(@signed_request['credits']['order_info'])
      event_id = order_info['_id']
      order_id = params["order_id"]
      logger.info "order_info =#{order_info}"
      logger.info "order id = #{order_id.to_json}"
      logger.info "event_id = #{event_id}" 
      logger.info order_info
      #retrieve order 
     
      auth = Authentication.find_by_uid(buyer_id)
      event = Event.find(event_id)
      logger.info "Account = #{auth.account.to_json}"
      logger.info "event = #{event.to_json}"
      neworder = Order.new(:event_id => event.id, :account_id => auth.account.id, :pay_provider => "facebook", :fb_order_id => order_id, :status => 'initiated', :token => token)
      
      if event
        #returns a facebook json item description 
        

        if neworder.save
          item = neworder.fb_item_info          
          response= item
          
        end
      end 
    elsif  method == "payment_status_update"
      
      
    elsif method == "" 

    end
   
   logger.info "response to facebook is #{response.to_json}"
   response_for_fb = JSON.pretty_generate(response)
   response_for_fb
  end  

  post :fb, :provides => :json do
    
    @oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_SECRET_KEY, 'https://purplepanda.heroku.com/fb/authenticate/')
    @signed_request = @oauth.parse_signed_request(params['signed_request'])
    logger.info "@signed_request = #{@signed_request.to_json}"
    logger.info "params passed in = #{params.to_json}"
    token = @signed_request['credits']['oauth_token'] 
    logger.info params["method"]
    method =  params["method"]
     buyer_id = params["buyer"]
    response = {}
    logger.info "method = #{method}"
    logger.info "buyer id = #{buyer_id}"
    if method == 'payments_get_items'
      
      #parse the oder info JSON fro FB
      order_info = JSON.parse(@signed_request['credits']['order_info'])
      event_id = order_info['_id']
      order_id = params["order_id"]
      logger.info "order_info =#{order_info}"
      logger.info "order id = #{order_id.to_json}"

      logger.info "event_id = #{event_id}" 
      logger.info order_info
      #retrieve order 
     
      auth = Authentication.find_by_uid(buyer_id)
      event = Event.find(event_id)
      logger.info "Account = #{auth.account.to_json}"
      logger.info "event = #{event.to_json}"
        
        #en
      if event
        #returns a facebook json item description 
         order = Order.first(:fb_order_id => order_id.to_s)
        logger.info "order === #{order.to_json}"
        if order.nil? 
          neworder = Order.new(:event_id => event.id, :account_id => auth.account.id, :pay_provider => "facebook", :fb_order_id => order_id, :status => 'initiated', :token => token)
        else
          neworder = order
        end 
         
        if neworder.save
          item = neworder.fb_item_info          
          response= item
          
        end
      end 
    elsif method == 'payments_status_update'
      #check the status of the payment by getting order details
      order_details = JSON.parse(@signed_request['credits']['order_details'])
      order_id = order_details['order_id']
      buyer = order_details['buyer']
      status = order_details['status']
      logger.info "order details = #{order_details.to_json}"
      logger.info "order_id = #{order_id.to_json}"
      logger.info "payment status update #{status}"
      logger.info "buyer = #{buyer}"
      if status == 'placed'
        #user has purchased the item prepare response for facebook
        order = Order.first(:fb_order_id => order_id.to_s)
        order.status = 'settled'
        if order.save   
          #if order update work construct facebook response
          
          response['content'] = {
            'status' => order.status,
            'order_id' => order_id,
          }
          response['method'] = method
        end 
      
      elsif status == 'disputed'
        #user is disputing the order track it in the system
        order =  Order.first(:fb_order_id => order_id)
        order.status = status
        if order.save 
        #if succesfully update status 
        end 

      elsif status == 'refunded'
         order = Order.first(:fb_order_id => order_id)
         order.status = status
         if order.save 
          #if sucessfully update some shit
         end
      end 

   end
   
   logger.info "response to facebook is #{response.to_json}"
   response_for_fb = JSON.pretty_generate(response)
   response_for_fb
  end  
  

  post :create do
   
    logger.debug params["order"].to_json
    @order = Order.new(params["order"])
    uri = Addressable::URI.new 
    uri.query_values= @order.event.fb_pay_request 
    url = 'https://www.facebook.com/dialog/pay?' + uri.query

    logger.info url
    if @order.save
     flash[:notice] = "order was successfully created. URL = #{url} ORDER = #{@order.to_json}"
  else 
     'ohh snap something went terribly wrong. RUN.'
   end 

  end
end
