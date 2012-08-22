Jp2.controllers :event do
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
get :index do
    @events = Event.all(:order => 'created_at desc')
    @videos = @events.map { |event| 'http://gdl.gfl.tv/video/eventpromo/' + event.gfl_id.to_s + '.mp4' }
    render 'events/index'
  end

  get :show, :with => :id do
    @event = Event.find_by_id(params[:id])
    if @event.videos 
      @promovid= @event.videos.first
    end
    render 'events/show'    
  end

  get :ustream do
    @uslides = Event.all(:order => 'created_at asc', :limit => 5)
    render 'events/ustream' , :layout => false
  end
  
  get :fb do
     @events = Event.all(:order => 'created_at asc', :limit => 5)
     @videos = gfl_url_for("promo", @events)
     # @videos = @events.map { |event| 'http://gdl.gfl.tv/video/eventpromo/' + event.gfl_id.to_s + '.mp4' }
     render 'events/fb' , :layout => false
  end
  


end
