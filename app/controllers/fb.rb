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
    if current_account.nil? 
      @oauth = Koala::Facebook::Oauth.new(FB_APP_ID, FB_APP_SECRET)
      signed_request_string = request.env.to_json

    end
    @signed_request_string
   end 


  post :index do
     @events = Event.all(:order => 'created_at asc', :limit => 5)
     @videos = gfl_url_for("promo", @events)
     # @videos = @events.map { |event| 'http://gdl.gfl.tv/video/eventpromo/' + event.gfl_id.to_s + '.mp4' }
     
     #render 'fb/index' , :layout => false
    @signed_request_string
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




end
