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
  key :streamhub_ids, Array, :typecast => "ObjectId"
  key :video_ids, Array, :typecast => "ObjectId"
  key :description, String, :default =>" "
  key :venue_id, ObjectId
  key :partner_id, ObjectId
  timestamps!

  many :callsheets, :in => :callsheet_id
  many :streamhubs, :in => :streamhub_ids
  many :videos, :in => :video_ids
  many :images
  many :orders 

  belongs_to :venue 
  belongs_to :partner

  before_save :get_location_points, :if => :location_points_set 
 #method returns latest poter url
 def poster_url
  if gfl_id.nil?
    img_url = 'placeholder.png'
  else
    img_url = "http://smedia.gfl.tv/images/events/#{gfl_id}.JPG"
  end
  img_url
 end
 
 ###
 #returns the available budget minus any crew assignments
 def budget_avail 
 avail = budget 

 call = Callsheet.where(:event_id => self.id)
  logger.info "avail = #{avail}, callsheets = #{call}"
 if avail > 0 then 
   call.each do |call|
     call.assigments.each do |a|
       avail -= a.dayrate
     end
    end
  end
  avail   
  end 

 def add_to_venue(venue)
  ##adds event id to venues 
  ## returns true or false 
  logger.info "this is venue id passed to add to venue #{venue.id}"
  self.venue_id = venue.id
  venue.events << self 
  venue.save!  
  self.save!
 end

 def fb_pay_request
   #returns a json object to generate the facebook pay dialog
   response = {}
   response[:method] = 'pay'
   response[:action] = 'buy_item'
   order = {}
   order['event_id'] = id
   
   response[:order_info] = order
   
   dev = {}
   dev['oscif']= true
   response[:dev_purchase_params] = dev
   response
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
