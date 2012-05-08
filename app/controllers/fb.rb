Jp2.controllers :fb do
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



  post :index do
     @oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_SECRET_KEY, 'https://purplepanda.heroku.com/fb/authenticate')
     @signed_request = @oauth.parse_signed_request(params['signed_request'])
     auth = Account.where("authentications.provider" => 'Facebook', "authentications.uid" => @signed_request['user_id']).first

     if auth
       
       
       # @videos = @events.map { |event| 'http://gdl.gfl.tv/video/eventpromo/' + event.gfl_id.to_s + '.mp4' }
       set_current_account(auth)
       

      else
      
        #new user that is not logged in and has no authentications on file 
        
        logger.info "user not logged nor is auth valid"
        redirect @oauth.url_for_auth_code(:permissions => "publish_stream")

      end
      @events = Event.all(:order => 'created_at asc', :limit => 5)
      @videos = gfl_url_for("promo", @events)
      render 'fb/index' , :layout => false 


  end

  get :index do
     @events = Event.all(:order => 'created_at asc', :limit => 5)
     @videos = gfl_url_for("promo", @events)
     # @videos = @events.map { |event| 'http://gdl.gfl.tv/video/eventpromo/' + event.gfl_id.to_s + '.mp4' }
     render 'fb/index' , :layout => false
  end

  get :show, :with => :id do
      @event = Event.find_by_id(params[:id])
     
    if @event.videos 
      @promovid= @event.videos.first
    end
    render 'fb/show', :layout => false   
  end

  post :authenticate do 
  

  end 
  

end
