class Admin < Padrino::Application
  register Padrino::Rendering
  register Padrino::Mailer
  register Padrino::Helpers
  register Padrino::Admin::AccessControl

  set :protection, :except => [:frame_options, :remote_token, :session_hijacking ]
  ##
  # Application configuration options
  #
  # set :raise_errors, true         # Raise exceptions (will stop application) (default for test)
  # set :dump_errors, true          # Exception backtraces are written to STDERR (default for production/development)
  # set :show_exceptions, true      # Shows a stack trace in browser (default for development)
  # set :logging, true              # Logging in STDOUT for development and file for production (default only for development)
  # set :public_folder, "foo/bar"   # Location for static assets (default root/public)
  # set :reload, false              # Reload application files (default in development)
  # set :default_builder, "foo"     # Set a custom form builder (default 'StandardFormBuilder')
  # set :locale_path, "bar"         # Set path for I18n translations (default your_app/locales)
  # disable :sessions               # Disabled sessions by default (enable if needed)
  # disable :flash                  # Disables sinatra-flash (enabled by default if Sinatra::Flash is defined)
  # layout  :my_layout              # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
  #

  set :admin_model, 'Account'
  set :login_page, "/admin/sessions/new"


  disable :store_location

  use OmniAuth::Builder do
    provider :twitter, TWITTER_APP_ID, TWITTER_APP_SECRET
    provider :facebook, FB_APP_ID, FB_APP_SECRET
 end
 Geokit::Geocoders::google = 'AIzaSyCarC9Mc24ezPR2Q-joO6fiZNRTxHqKq9Q'

  access_control.roles_for :any do |role|
    role.protect "/"
    role.allow "/sessions"
    role.allow "/auth"

  end

  access_control.roles_for :admin do |role|
    role.project_module :actors, '/actors'
    role.project_module :partners, '/partners'
    role.project_module :orders, '/orders'
    role.project_module :images, '/images'
    role.project_module :venues, '/venues'
    role.project_module :assigments, '/assigments'
    role.project_module :authentications, "/authentications"
     role.project_module :callsheets, "/callsheets"
    role.project_module :events, "/events"
    role.project_module :videos, "/videos"
    role.project_module :accounts, "/accounts"
    role.project_module :streamhubs, "/streamhubs"
  end

   access_control.roles_for :batman do |role|
    role.project_module :authentications, "/authentications"
    role.project_module :crewmembers, "/crewmembers"
    role.project_module :callsheets, "/callsheets"
    role.project_module :fights, "/fights"
    role.project_module :events, "/events"
    role.project_module :videos, "/videos"
    role.project_module :accounts, "/accounts"
  end
  
  
  access_control.roles_for :partner do |role|
    role.allow "/accounts/edit"
    role.allow "/accounts/update"
    role.allow "/callsheets/show"
    role.allow "/accounts/show/"
    role.project_module :assigments, "/assigments"
    role.project_module :authentications, "/authentications"
  end

  
  access_control.roles_for :crew do |role|
    role.allow "/accounts/edit"
    role.allow "/accounts/update"
    role.allow "/accounts/show/"
    role.allow "/callsheets/show"
    role.project_module :assigments, "/assigments"
    role.project_module :authentications, "/authentications"
  end
  
  ###settiung up mailer 
  set :delivery_method, :smtp => { 
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :user_name            => 'gigs@pandafeed.tv',
  :password             => EMAIL_PASSWORD,
  :authentication       => :plain,
  :domain               => "pandafeed.tv",
  :enable_starttls_auto => true  
}
    ##
    ##
    ##authentication logic  
    ## for OAUTH USING FACEBOOK AND TWITTER
    get :auth, :map => '/auth/:provider/callback' do
     omniauth = request.env["omniauth.auth"]
     logger.info  omniauth
      auth = Account.where("authentications.provider" => omniauth['provider'], "authentications.uid" => omniauth['uid']).first
      logger.info auth
      logger.info current_account.to_json
      if auth
        #if not logged in but have authentication on file

        flash[:notice] = 'Signed in Successfully'
        set_current_account(auth.account)
        redirect '/admin/authentications'
      elsif logged_in?
        #logged in add another authentication to the account object
        credentials = Hash.new
        credentials['provider'] = omniauth['provider']
        credentials['uid'] = omniauth['uid']
        credentials['info'] = omniauth['info']
        credentials['credentials'] = omniauth['credentials']
        logger.info "saved credentials #{credentials.to_json}"
        logger.info omniauth.to_json
        current_account.authentications.create(credentials)
        if current_account.save
          flash[:notice] = "Authentication Successful"
          redirect '/admin/authentications'
        end

        
      else
        #new user that is not logged in and has no authentications on file 
        logger.info "user not logged nor is auth valid"
        @account = Account.new(:name => omniauth["info"]["name"], :email => omniauth["info"]["email"], :role => "users", :provider => omniauth["provider"], :uid => omniauth["uid"])
        @account.authentications.build(:provider => omniauth["provider"], :uid => omniauth["uid"])
        @account.save!
        set_current_account(@account)
        redirect '/admin/authentications'
      end
    
    redirect '/'
  
  end




end
