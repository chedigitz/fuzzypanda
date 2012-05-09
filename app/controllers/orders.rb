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
    logger.info params[" method"]
    method = params[" method"]

    if method == "payments_get_items" 
      order_info = params["order_info"]
      item_id = order_info["item_id"]
      order_id = params["order_id"]

      #retrieve order 
      buyer_id = params["buyer"]
      account = Authentication.where(:uid => buyer_id)     
      localitem = Event.find(item_id)
      neworder = Order.new(:event_id => localitem.id, :account_id => account.id, :pay_provider => "facebook", :fb_order_id => order_id)
      if localitem
        #returns a facebook json item description 
        item = neworder.fb_pay
        
      response = item
      end 
    elsif  method == "payment_status_update"


    elsif method == "" 

    end
      
   response
  end  
  

post :create do
    logger.debug params["order"].to_json
    
    @order = Order.new(params["order"])
    logger.debug "this is the facebook order response #{@order.fb_pay}"
    logger.debug "this is the facebook buy button request #{@order.event.fb_pay_request}"
    uri = Addressable::URI.new 
    uri.query_values= @order.event.fb_pay_request 
    url = 'https://www.facebook.com/dialog/pay?' + uri.query

    logger.info url
    #if @order.save
        #@callsheet = Callsheet.find(@order.callsheet_id)
        #@order.add_to_callsheet(@callsheet)
        #@account = Account.find(@order.account_id)
        #@account.add_to_callsheet(@callsheet)
      flash[:notice] = 'order was successfully created. URL = #{url} ORDER = #{@order.to_json}'
      #redirect url(:callsheets, :edit, :id => @order.callsheet_id)
    #else
      #render 'orders/new'
    
    #ends
  end
end
