class Event
  include MongoMapper::Document

  # key <name>, <type>
  key :title, String
  key :url, String
  key :price, Float
  key :location, Array
  key :hashtag, String
  key :callsheet_id, Array
  timestamps!

  many :callsheets, :in => :callsheet_id
  many :images
  many :videos
  
  before_save :get_location_points, :if => :location_points_set 

  private 
  def get_location_points
      location_points = GeoKit::Geocoders::YahooGeocoder.geocode location[0]
      self.location = location_points.ll
  end
  
  def location_points_set
      location.kind_of?(Array) || location.present?
  end    

end
