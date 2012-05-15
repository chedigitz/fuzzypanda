Admin.controllers :partners do

  get :index do
    @partners = Partner.all
    render 'partners/index'
  end

  get :new do
    @partner = Partner.new
    render 'partners/new'
  end

  post :create do
    @partner = Partner.new(params[:partner])
    if @partner.save
      flash[:notice] = 'Partner was successfully created.'
      redirect url(:partners, :edit, :id => @partner.id)
    else
      render 'partners/new'
    end
  end

  get :edit, :with => :id do
    @partner = Partner.find(params[:id])
    render 'partners/edit'
  end

  put :update, :with => :id do
    @partner = Partner.find(params[:id])
    if @partner.update_attributes(params[:partner])
      flash[:notice] = 'Partner was successfully updated.'
      redirect url(:partners, :edit, :id => @partner.id)
    else
      render 'partners/edit'
    end
  end

  delete :destroy, :with => :id do
    partner = Partner.find(params[:id])
    if partner.destroy
      flash[:notice] = 'Partner was successfully destroyed.'
    else
      flash[:error] = 'Unable to destroy Partner!'
    end
    redirect url(:partners, :index)
  end
end
