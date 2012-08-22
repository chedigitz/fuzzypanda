Admin.controllers :sessions do

  get :new do
    render "/sessions/new", nil, :layout => false
  end

  post :create do
    if account = Account.authenticate(params[:email], params[:password])
      set_current_account(account)
      redirect url(:base, :index)
    elsif Padrino.env == :development && params[:bypass]
      account = Account.first
      set_current_account(account)
      redirect url(:base, :index)
    else
      params[:email], params[:password] = h(params[:email]), h(params[:password])
      flash[:warning] = "Login or password wrong."
      redirect url(:sessions, :new)
    end
  end

    get :auth, :map => '/auth/:provider/callback' do
     omniauth = request.env["omniauth.auth"]
     logger.info  omniauth
      auth = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
      logger.info auth
      
      if auth
        #if not logged in but have authentication on file
        flash[:notice] = 'Signed in Successfully'
        set_current_account(auth.account)
        redirect '/admin/authentications'
      elsif logged_in?
        #logged in add another authentication to the account object
        current_account.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
        flash[:notice] = "Authentication Successful"
        redirect '/admin/authentications'
      else
        #new user that is not logged in and has no authentications on file 
        @account = Account.new(:name => omniauth["info"]["name"], :email => omniauth["info"]["email"], :role => "users", :provider => omniauth["provider"], :uid => omniauth["uid"])
        @account.authentications.build(:provider => omniauth["provider"], :uid => omniauth["uid"])
        @account.save!
        set_current_account(@account)
        redirect '/admin/authentications'
      end
    
      redirect '/'
    end

  delete :destroy do
    set_current_account(nil)
    redirect url(:sessions, :new)
  end
end
