class Venue
  include MongoMapper::Document

  # key <name>, <type>
  key :location, Array
  key :foursquare_id, String
  key :twitter_place_id, String
  key :twitter_uid, String
  key :url, String
  key :phone, String
  key :speed_score, Float
  key :event_ids, Array, :index => true, :typecast => "ObjectId"
  key :info, Hash 
  key :contact, Hash
  key :location_info, Hash
  key :verified, Boolean
  key :tips, Hash
  key :name, String
  key :fs_stats, Hash


  timestamps!

  many :events, :in => :event_ids 
  before_save :get_location_points, :if => :location_points_set

  def search_foursquare_venue(event_location, term)
    client = Foursquare2::Client.new(:client_id => '1Z3UES45B312ZRK5342HUWQYIMC4MFRA0JXZITCAGV4VZWUE', :client_secret => 'PB443NMF1SIISHU0ZUSDO2DMPVVPN0EQPFCNI5IJZ4XLQQ4O')
    venue = client.search_venues(:ll => latlongo, :query => term, :limit => 10)
    groups = venue
    items = groups.groups
    venue = items[0]["items"][0]["id"]
    logger.info "this is venue items #{venue.inspect}"
    venue 
    
  end

  def foursquare_update(venue_id)
    unless venue_id.nil?
      client = Foursquare2::Client.new(:client_id => '1Z3UES45B312ZRK5342HUWQYIMC4MFRA0JXZITCAGV4VZWUE', :client_secret => 'PB443NMF1SIISHU0ZUSDO2DMPVVPN0EQPFCNI5IJZ4XLQQ4O')
      foursquare_info = client.venue(venue_id) 
      self.location_info = foursquare_info["location"]
      self.contact= foursquare_info["contact"]
      self.name = foursquare_info["name"]
      self.tips = foursquare_info["tips"]
      self.fs_stats = foursquare_info["stats"]
      self.verified = foursquare_info["verified"]
      self.url = foursquare_info["url"]
      self.twitter_place_id = foursquare_info["twitter"]
      logger.info "this is location_info = #{self.location_info.to_json}"
      logger.info "this is contact = #{self.contact.to_json}"
      logger.info "this is tips size = #{self.tips.size}"

  
    end 
    
  end

  def tips_limit(limit)
    #returns foursqaure tips based on limit
     all_tips = self.tips["groups"][0]["items"]
     all_tips = all_tips.reverse
     if limit >= all_tips.size
        tips_returned = all_tips
     else

        tips_returned = all_tips[0..limit]
     end
     tips_returned 
  end

  private 
  def get_location_points
      unless location.empty?
        location_points = GeoKit::Geocoders::GoogleGeocoder.geocode location[0]
        self.location = location_points.ll
        #update foursquare now that location has been updated

      end
  end
  
  def location_points_set
      self.location_changed? || location.present?
  end   



end