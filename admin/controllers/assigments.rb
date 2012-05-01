Admin.controllers :assigments do

  get :index do
    if current_account.role == 'admin'
      @assigments = Assigment.where(:conditions => {:settled => false}).sort(:update_at.desc)
    elsif current_account.role == 'partner'
      @assigments = Assigment.all
          
    else 
      #for crew 
      @assigments = current_account.assigments
      logger.info "this is @ASSIGMENTS #{@assigments.to_json}"
    end
    #calculate total payments    

    @dwolladollaz = sumup(@assigments)
    render 'assigments/index'
  end

  get :all do 
    if current_account.role == 'admin'
      @assigments = Assigment.all
    else
      @assigments = Assigment.where(:conditions => {:account_id => current_account.id }).sort(:updated_at.desc)
    end

    render 'assigments/index'


  end 

  get :booked do
    @callsheets = Callsheet.where(:conditions => {:call_time.gte =>Time.now, :account_ids => current_account.id })
    @assigments = []
    logger.info "this is ASSIGMENTS IN @CALLSHEET = #{@callsheets.to_json}"

    @callsheets.each do |c|
          logger.info "this is ASSIGMENTS IN @CALLSHEET = #{c.to_json}"
      @assigments << Assigment.where(:conditions => {:callsheet_id => c.id, :account_id => current_account.id})
    end 
    @dwolladollaz = sumup(@assiments)
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
        @callsheet = Callsheet.find(@assigment.callsheet_id)
        @assigment.add_to_callsheet(@callsheet)
        @account = Account.find(@assigment.account_id)
        @account.add_to_callsheet(@callsheet)
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
