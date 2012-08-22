# Helper methods defined here can be accessed in any controller or view in the application

Jp2.helpers do
  # def simple_helper_method
  #  ...
  # end

  def to_address(location_points)
  	#accepts location array then converts to adress
  	reverse = GoogleGeocoder.reverse_geocode(location_points)
  	reverse.full_address
  end 

   def gfl_url_for (type,array)
    # receieves a type "video", "promo","image"
    # accepts an array an returns an arrary populated with the correct URLs
    # accepts a value for the table ie: "gfl_id"
    # returns an array populated with the URL for the array of GFL ids  
    promo = 'http://gdl.gfl.tv/video/eventpromo/'
    video = ''
    image = ''
    newarray = []
    if type == 'promo'
      array.each do |i|
        newarray << promo + i.gfl_id.to_s + '.mp4'
      end
    elsif type == 'video' 
      array.each do |i|
        newarray << video + i.gfl.id.to_s + '.mp4'
      end
    elsif type == 'image'
      array.each do |i|
        newarray << image + i.gfl.id.to_s + '.mp4'
      end
    end
    newarray
  end
end
