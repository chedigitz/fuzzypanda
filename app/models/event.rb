class Event
  include MongoMapper::Document

  # key <name>, <type>
  key :title, String
  key :url, String
  key :price, Float
  key :location, Array
  key :hashtag, String
  key :callsheet_id, Array
  key :gfl_id, Integer
  key :budget, Float
  key :venue_tag, String
  key :showdate, Time
  key :showtime, Time
  timestamps!

  many :callsheets, :in => :callsheet_id
  many :images
  many :videos
  
  before_save :get_location_points, :if => :location_points_set 
 #method returns latest poter url
 def poster_url
  if gfl_id
    gfl_url = "http://smedia.gfl.tv/images/events/#{gfl_id}.JPG"
  end
  gfl_url
 end

  private 
  def get_location_points
      unless location.empty?
        location_points = GeoKit::Geocoders::GoogleGeocoder.geocode location[0]
        self.location = location_points.ll
      end
  end
  
  def location_points_set
      self.location_changed? || location.present?
  end    

end
