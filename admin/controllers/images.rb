Admin.controllers :images do

  get :index do
    @images = Image.all
    render 'images/index'
  end

  get :new, :with => :id do

    if params[:id]
      @event = Event.find(params[:id])
      logger.debug @event.to_json
      @image = Image.new(:event => @event)
      logger.debug @image.to_json
      logger.debug params[:image.to_json]
    end
    render 'images/new'
  end

  post :create do
    @image = Image.new(params[:image])
    if @image.save
      flash[:notice] = 'Image was successfully created.'
      redirect url(:images, :edit, :id => @image.id)
    else
      render 'images/new'
    end
  end

  get :edit, :with => :id do
    @image = Image.find(params[:id])
    render 'images/edit'
  end

  put :update, :with => :id do
    @image = Image.find(params[:id])
    if @image.update_attributes(params[:image])
      flash[:notice] = 'Image was successfully updated.'
      redirect url(:images, :edit, :id => @image.id)
    else
      render 'images/edit'
    end
  end

  delete :destroy, :with => :id do
    image = Image.find(params[:id])
    if image.destroy
      flash[:notice] = 'Image was successfully destroyed.'
    else
      flash[:error] = 'Unable to destroy Image!'
    end
    redirect url(:images, :index)
  end
end
