class Account
  include MongoMapper::Document
  attr_accessor :password, :password_confirmation

  # Keys
  key :name,             String
  key :surname,          String
  key :email,            String
  key :crypted_password, String
  key :role,             String
  key :time_zone,        String
  key :location,          Array
 
  # Validations
  validates_presence_of     :email, :role
  validates_presence_of     :password,                   :if => :password_required
  validates_presence_of     :password_confirmation,      :if => :password_required
  validates_length_of       :password, :within => 4..40, :if => :password_required
  validates_confirmation_of :password,                   :if => :password_required
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_format_of       :role,     :with => /[A-Za-z]/

  #ASSOCIATIONS
  many :authentications
  many :assigments


  # Callbacks
  before_save :encrypt_password, :if => :password_required
  before_save :get_location_points, :if => :location_points_set 


  ##
  # This method is for authentication purpose
  #
  def self.authenticate(email, password)
    account = first(:email => email) if email.present?
    account && account.has_password?(password) ? account : nil
  end

  def has_password?(password)
    ::BCrypt::Password.new(crypted_password) == password
  end

  ##
  # This method returns the latest saved social url
  def avatar
   
    last_auth = Authentication.last( :account_id => self.id)
    logger.debug last_auth.to_json
    if last_auth 
      
      url = last_auth.info["image"]
    elsif last_auth.nil?
       url = "placeholder.png"
    end 
       logger.info url
    url
  end
  
  def add_to_callsheet(callsheet)
    callsheet.accounts << self
    callsheet.save!
    
  end

  private
    def encrypt_password
      self.crypted_password = ::BCrypt::Password.create(password)
    end

    def password_required
      crypted_password.blank? || password.present?
    end

  #geo code the location info
  def get_location_points
      #only set location when there is location data s
      logger.info location
      if location
        location_points = GeoKit::Geocoders::YahooGeocoder.geocode location[0]
        self.location = location_points.ll
      end
  end
  
  def location_points_set
      location.kind_of?(Array) || location.present?
  end    

end
