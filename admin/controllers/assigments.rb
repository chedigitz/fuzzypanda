Admin.controllers :assigments do

  get :index do
    @assigments = Assigment.all
    render 'assigments/index'
  end

  get :new do
    @assigment = Assigment.new
    render 'assigments/new'
  end

  post :create do
    logger.debug params["assigment"].to_json
    @assigment = Assigment.new(params["assigment"])
    
    if @assigment.save
      flash[:notice] = 'Assigment was successfully created.'
      redirect url(:callsheets, :edit, :id => @assigment.callsheet_id)
    else
      render 'assigments/new'
    end
  end

  get :edit, :with => :id do
    @assigment = Assigment.find(params[:id])
    render 'assigments/edit'
  end

  put :update, :with => :id do
    logger.debug params.to_json

    @assigment = Assigment.find(params[:id])
    if @assigment.update_attributes(params[:assigment])
      flash[:notice] = 'Assigment was successfully updated.'
      redirect url(:assigments, :edit, :id => @assigment.id)
    else
      render 'assigments/edit'
    end
  end

  delete :destroy, :with => :id do
    assigment = Assigment.find(params[:id])
    if assigment.destroy
      flash[:notice] = 'Assigment was successfully destroyed.'
    else
      flash[:error] = 'Unable to destroy Assigment!'
    end
    redirect url(:assigments, :index)
  end
end
