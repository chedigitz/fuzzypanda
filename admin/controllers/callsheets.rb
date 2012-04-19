Admin.controllers :callsheets do

  get :index do
    @callsheets = Callsheet.all
    render 'callsheets/index'
  end

  get :new do
    if params[:id]
      @event = Event.find(params[:id])
      logger.debug @event.to_json
      @callsheet = Callsheet.new(:event => @event)
      logger.debug @callsheet.to_json
      logger.debug params[:callsheet].to_json
    end
    render 'callsheets/new'
  end

  post :create do
    logger.debug params[:callsheet]
    @event= Event.find(params[:callsheet][:event_id]) 
    @callsheet = Callsheet.new(params[:callsheet])
    
    logger.debug @callsheet.to_json
    if @callsheet.save
       flash[:notice] = 'Callsheet was successfully created.'
      redirect url(:callsheets, :edit, :id => @callsheet.id)
    else
      render 'callsheets/new'
    end
  end


  get :edit, :with => :id do
    @callsheet = Callsheet.find(params[:id])
    logger.debug @callsheet.to_json
    @crew = Account.all("role" => "crew")
    logger.info "CALL = #{@callsheet.to_json}"
    @squad = "THIS IS CALL SHEET assigments #{@callsheet.assigments.to_json}"
    logger.debug @squad.to_json
    render 'callsheets/edit'
  end

  get :show, :with => :id do 
     @callsheet = Callsheet.find(params[:id])
     
     if @callsheet.event.venue_tag
       @venue = venue_search(@callsheet.event.location[0], @callsheet.event.venue_tag)
       logger.info "VENUE SEARCH = #{@venue.to_json}"
    end

    render 'callsheets/show'
  end

  put :update, :with => :id do
    @callsheet = Callsheet.find(params[:id])
    if @callsheet.update_attributes(params[:callsheet])
      flash[:notice] = 'Callsheet was successfully updated.'
      redirect url(:callsheets, :edit, :id => @callsheet.id)
    else
      render 'callsheets/edit'
    end
  end

  delete :destroy, :with => :id do
    callsheet = Callsheet.find(params[:id])
    if callsheet.destroy
      flash[:notice] = 'Callsheet was successfully destroyed.'
    else
      flash[:error] = 'Unable to destroy Callsheet!'
    end
    redirect url(:callsheets, :index)
  end
end
