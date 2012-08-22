module SecureOnlyInitializer
  def self.registered(app)
    app.use Rack::SecureOnly, :if => Padrino.env == :development
  end
end
