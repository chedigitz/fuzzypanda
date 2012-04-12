Admin.controllers :streams do

  get :index do
    @streams = Stream.a;;
    render 'streams/index'
  end

  get :new do
    @stream = Stream.new
    render 'streams/new'
  end

  post :create do
    @stream = Stream.new(params[:stream])
    if @stream.save
      flash[:notice] = 'Stream was successfully created.'
      redirect url(:streams, :edit, :id => @stream.id)
    else
      render 'streams/new'
    end
  end

  get :edit, :with => :id do
    @stream = Stream.find(params[:id])
    render 'streams/edit'
  end

  put :update, :with => :id do
    @stream = Stream.find(params[:id])
    if @stream.update_attributes(params[:stream])
      flash[:notice] = 'Stream was successfully updated.'
      redirect url(:streams, :edit, :id => @stream.id)
    else
      render 'streams/edit'
    end
  end

  delete :destroy, :with => :id do
    stream = Stream.find(params[:id])
    if stream.destroy
      flash[:notice] = 'Stream was successfully destroyed.'
    else
      flash[:error] = 'Unable to destroy Stream!'
    end
    redirect url(:streams, :index)
  end
end
