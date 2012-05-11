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
  before :index do 
       unless logged_in?
         if params['signed_request']
           @oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_SECRET_KEY, 'https://purplepanda.heroku.com/fb/authenticate/')
           @signed_request = @oauth.parse_signed_request(params['signed_request'])
           auth = Account.where("authentications.provider" => 'facebook', "authentications.uid" => @signed_request['user_id']).first
          
           if auth
             #if authentication exist log user set the current account to the fb uid
       
            # @videos = @events.map { |event| 'http://gdl.gfl.tv/video/eventpromo/' + event.gfl_id.to_s + '.mp4' }
            set_current_account(auth)
            else
            #new user that is not logged in and has no authentications on file 
           logger.info "user not logged nor is auth valid"
           redirect @oauth.url_for_oauth_code(:permissions => "publish_stream, publish_checkins, rsvp_event, create_event, user_events, user_location, email, publish_actions, user_actions.video")
           end
         elsif 
          set_current_account(current_user)

           

         end
      end
  end

  before :live do 
    @event = Event.find(params[:id])
    order = Order.first(:account_id => current_account.id, :event_id => @event.id, :status => 'settled')
    logger.info "order = #{order}"
    if order.nil?
      redirect url(:fb, :show, :id => @event.id)
    end 
  end 



  post :index do
 
        @events = Event.all(:order => 'created_at asc', :limit => 10)
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

  get :authenticate do 
     @oauth = Koala::Facebook::OAuth.new(FB_APP_ID, FB_SECRET_KEY, 'https://purplepanda.heroku.com/fb/authenticate/')
     code = params['code']
     oauth_token = @oauth.get_access_token(code)
     graph = Koala::Facebook::API.new(oauth_token)
     user_data = graph.get_object('me')
     user_picture = graph.get_picture('me')
     account = Account.first(:email => user_data['email'])
     #auth = Account.where("authentications.provider" => 'facebook', "authentications.uid" => user_data['id']).first
    if account

        #existing account update permisions
        credentials = Hash.new
        credentials['provider'] = 'facebook'
        credentials['uid'] = user_data['id']
        credentials['info'] = user_data
        credentials['info']['image'] = user_picture
        set_current_account(account)
        account.authentications.create(credentials)
     else
      #new account create account and build authencations 
       @account = Account.new(:name => user_data['first_name'], :surname => user_data['last_name'], :email => user_data["email"], :role => "users", :provider => 'facebook', :uid => user_data['id'])
       @account.authentications.build(:provider => 'facebook', :uid => user_data['id'])
       @account.save!
       set_current_account(@account)
     end 
     redirect url(:fb, :index)
  end 
get :live, :with => :id do 
    @event = Event.find(params[:id])
    order = Order.first(:account_id => current_account.id, :event_id => @event.id)
    render 'fb/live', :layout => false 
end 

end
