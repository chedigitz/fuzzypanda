module OmniauthInitializer
  def self.registered(app)
    app.use OmniAuth::Builder do
      provider :developer unless Padrino.env == :production
      provider :twitter,  '78dWjnUfFYEq2Ucdvd6Q', 'kKq99vTtStdhTMSSeUbG1mFdKMsUY6gtAwAy6h80'
      provider :facebook, '360073534017902', '39b8113aaadae3eff954a8ba8a2286df'
      # provider :twitter, 'consumer_key', 'consumer_secret'
      # provider :facebook, 'app_id', 'app_secret'
    end

  end
end
