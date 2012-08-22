Admin.controllers :videos do

  get :index do
    @videos = Video.all
    render 'videos/index'
  end

  get :new do
    if params[:event_id]
      @event = Event.find_by_id(params[:event_id])
      '@video = Video.new(params[:video])'
      logger.debug @event.to_json
      @video = Video.new
      render 'videos/new'
    else
      @video = Video.new
      render 'videos/new'
    end     
  end

  post :create do
    logger.info "this is params #{params.to_json}"
    @event = Event.find(params[:event_id])
    @video = Video.new(params[:video])
    logger.info @video.to_json
    if @video.save
      flash[:notice] = 'Video was successfully created.'
      redirect url(:videos, :edit, :id => @video.id)
    else
      render 'videos/new'
    end
  end

  get :edit, :with => :id do
    @video = Video.find(params[:id])
    @event = @video.event
    render 'videos/edit'
  end

  put :update, :with => :id do
    @video = Video.find(params[:id])
    if @video.update_attributes(params[:video])
      flash[:notice] = 'Video was successfully updated.'
      redirect url(:videos, :edit, :id => @video.id)
    else
      render 'videos/edit'
    end
  end

  delete :destroy, :with => :id do
    video = Video.find(params[:id])
    if video.destroy
      flash[:notice] = 'Video was successfully destroyed.'
    else
      flash[:error] = 'Unable to destroy Video!'
    end
    redirect url(:videos, :index)
  end
end
