# Helper methods defined here can be accessed in any controller or view in the application

Admin.helpers do
  # def simple_helper_method
  #  ...
  # end

  def to_address(location_points)
  	#accepts location array then converts to adress
  	logger.info "THIS IS LOCATION POINTS #{location_points[0]}"
  	if location_points.empty? || location_points[0]== ","
  		"enter location info to make life awesome"
  	else
  	  points = GeoKit::LatLng.normalize(location_points[0])
  	  reverse = GeoKit::Geocoders::GoogleGeocoder.reverse_geocode(location_points[0])
  	  adress= reverse.full_address
      logger.info "this is POINTS #{location_points[0]}"
 	  logger.debug "this is location return #{reverse}"	 	
  	  adress
  	end
  end 

  def venue_search(latlongo, term)
    #accepts location points array
     
    client = Foursquare2::Client.new(:client_id => '1Z3UES45B312ZRK5342HUWQYIMC4MFRA0JXZITCAGV4VZWUE', :client_secret => 'PB443NMF1SIISHU0ZUSDO2DMPVVPN0EQPFCNI5IJZ4XLQQ4O')
    venue = client.explore_venues(:ll => latlongo, :query => term, :limit => 10)
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

  def account_image(account)
  	image= Account.image
    image
  end

  def g_maps_directions_url(arrayfrm, arrayto)
  	#accepts a to and from location array GEO point
  	#returns a URL 
  	url = "http://maps.google.com/?saddr=#{arrayfrm[0].to_s}&daddr=#{arrayto[0].to_s}"
  	logger.info "Array from is #{arrayfrm.to_json} ARRAY TO IS #{arrayto.to_json}"
  	logger.info "URL RIGHT NOW IS #{url}"
  	url
	
  end
end
