Admin.controllers :streamhubs do

  get :index do
    @streamhubs = Streamhub.all
    render 'streamhubs/index'
  end

  get :new do
    @streamhub = Streamhub.new
    if params[:event_id]
      event_id = params[:event_id]
      @event = Event.find(event_id)
    end
    render 'streamhubs/new'
  end

  post :create do
    @streamhub = Streamhub.new(params[:streamhub])
    if @streamhub.save
      flash[:notice] = 'Streamhub was successfully created.'
      redirect url(:streamhubs, :edit, :id => @streamhub.id)
    else
      render 'streamhubs/new'
    end
  end

  get :edit, :with => :id do

    @streamhub = Streamhub.find(params[:id])
    @event = Event.find(@streamhub.event_id)
    render 'streamhubs/edit'
  end

  put :update, :with => :id do
    @streamhub = Streamhub.find(params[:id])
    if @streamhub.update_attributes(params[:streamhub])
      flash[:notice] = 'Streamhub was successfully updated.'
      redirect url(:streamhubs, :edit, :id => @streamhub.id)
    else
      render 'streamhubs/edit'
    end
  end

  delete :destroy, :with => :id do
    streamhub = Streamhub.find(params[:id])
    if streamhub.destroy
      flash[:notice] = 'Streamhub was successfully destroyed.'
    else
      flash[:error] = 'Unable to destroy Streamhub!'
    end
    redirect url(:streamhubs, :index)
  end
end
