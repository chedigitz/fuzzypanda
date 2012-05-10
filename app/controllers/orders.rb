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
  get :new, :with => :id do
    

  end
  
  get :fb do 
    logger.info params[" method"]
    method = params[" method"]

    if method == "payments_get_items" 
      order_info = params["order_info"]
      item_id = order_info["item_id"]

      #retrieve order 
      
      localitem = Order.find(item_id)
      if localitem
        #returns a facebook json item description 
        item = localitem.fb_pay
        
      response = item
      end 
    elsif  method == "payment_status_update"


    elsif method == "" 

    end
      
   response
  end

  post :fb do
    
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
      
      order_info = @signed_request['credits']['order_info']
      order_id = params["order_id"]
      logger.info "order_info =#{order_info}"
      logger.info "order id = #{order_id.to_json}" 
      logger.info order_info
      #retrieve order 
     
      auth = Authentication.find_by_uid(buyer_id)
      event = Event.find(order_info)
      logger.info "Account = #{auth.account.to_json}"
      logger.info "event = #{event}"
      neworder = Order.new(:event_id => order_info, :account_id => auth.account.id, :pay_provider => "facebook", :fb_order_id => order_id, :status => 'initiated', :token => token)
      
      if event
        #returns a facebook json item description 
        item = neworder.fb_item_info

        if @neworder.save
                  
          response['content'] = item
          response['method'] = method  
        end
      end 
    elsif  method == "payment_status_update"
      
      
    elsif method == "" 

    end
   

   response.to_json
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
