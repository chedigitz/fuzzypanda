# Helper methods defined here can be accessed in any controller or view in the application

Admin.helpers do
  # def simple_helper_method
  #  ...
  # end

  def to_address(location_points)
  	#accepts location array then converts to adress
  	points = GeoKit::LatLng.normalize(location_points[0],location_points[1])
  	reverse = GeoKit::Geocoders::GoogleGeocoder.reverse_geocode(points)
  	reverse.full_address
  end 
end
