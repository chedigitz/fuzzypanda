# Helper methods defined here can be accessed in any controller or view in the application

Jp2.helpers do
  # def simple_helper_method
  #  ...
  # end

  def to_adress(location_points)
  	#accepts location array then converts to adress
  	reverse = GoogleGeocoder.reverse_geocode(location_points)
  	reverse.full_address
  end 
end
