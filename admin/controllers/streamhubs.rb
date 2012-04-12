Admin.controllers :streamhubs do

  get :index do
    @streamhubs = Streamhub.all
    render 'streamhubs/index'
  end

  get :new do
    @streamhub = Streamhub.new
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
