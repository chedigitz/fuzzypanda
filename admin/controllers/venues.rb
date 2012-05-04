Admin.controllers :venues do

  get :index do
    @venues = Venue.all
    render 'venues/index'
  end

  get :new do

    if params[:id]
      @event = Event.find(params[:id])
      logger.debug @event.to_json
      @venue= Venue.new
      
      @venue.location = @event.location 
      logger.debug @callsheet.to_json
   
      @venue.foursquare_id = venue_search(@event.location[0], @event.venue_tag)
      logger.info "this is @venue.foursquare_id = #{@venue.foursquare_id}"
    end
    render 'venues/new'
  end

  post :create do
    @venue = Venue.new(params[:venue])
    @venue.foursquare_update(@venue.foursquare_id)
    logger.info "this is params at venue create #{params[:venue].to_json}"
    @event= Event.find(params[:venue][:event_id])
    if @venue.save
      @event.add_to_venue(@venue)
      flash[:notice] = 'Venue was successfully created.'
      redirect url(:venues, :edit, :id => @venue.id)
    else
      render 'venues/new'
    end
  end

  get :edit, :with => :id do
    @venue = Venue.find(params[:id])
    @event = Event.find(@venue.events[0].id)
    render 'venues/edit'
  end

  put :update, :with => :id do
    @venue = Venue.find(params[:id])
    if @venue.update_attributes(params[:venue])
      flash[:notice] = 'Venue was successfully updated.'
      redirect url(:venues, :edit, :id => @venue.id)
    else
      render 'venues/edit'
    end
  end

  delete :destroy, :with => :id do
    venue = Venue.find(params[:id])
    if venue.destroy
      flash[:notice] = 'Venue was successfully destroyed.'
    else
      flash[:error] = 'Unable to destroy Venue!'
    end
    redirect url(:venues, :index)
  end
end
