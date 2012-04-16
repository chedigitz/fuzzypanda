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

  def venue_search(latlongo)
    #accepts location points array 
    client = Foursquare2::Client.new(:client_id => '1Z3UES45B312ZRK5342HUWQYIMC4MFRA0JXZITCAGV4VZWUE', :client_secret => 'PB443NMF1SIISHU0ZUSDO2DMPVVPN0EQPFCNI5IJZ4XLQQ4O')
    venue = client.explore_venues(:ll => latlongo, :section => 'food', :limit => 10)
  	venue 
  end

  def distance_between(arrayfrm, arrayto)
     #accepts to GEO point ["35,-12"] locations returns miles
     # 
  	loc_a = GeoKit::LatLng.normalize(arrayfrm[0],arrayfrm[1])
  	loc_b = GeoKit::LatLng.normalize(arrayto[0], arrayto[1])
  	distance = loc_a.distance_to(loc_b)
  	distance
  	
  end


  def provider_img_url(auth_info)
      #accepts authentication object returns proper avatar 
      if auth_info.provider = "facebook"
      	url = "https://graph.facebook.com/#{authentication.uid}/picture"
      
      elsif auth_info.provider = "twitter"
      	
      	
      end
      url
  end

end
