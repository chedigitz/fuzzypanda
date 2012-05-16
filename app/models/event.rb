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
  key :fb_event_id, String
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

 def featured_videos
  #returns featured videos objects for the event
  #or an empty array if none 
  feat_vids = Video.all(:event_id => id, :featured => true)
  logger.info "this is feature videos #{feat_vids.to_json}"
  feat_vids
 end
def get_fb_id
  auth = Authentication.first(:account_id => event.partner.account.id, :provider => 'facebook')
  if fb_event_id.empty?
     graph = Koala::Facebook::GraphAPI.new(auth.credentials['token'])
     params  = {
      :picture => self.poster_url,
      :name => "#{title}",
      :description => "#{description}",
      :start_time => showdate,
      :end_time => showdate+4.hours
     }

    fb_event_id =  graph.put_object('#auth.uid', 'events', params)
    save!
    
  end 
  fb_event = fb_event_id
  fb_event
end 
  
def get_fb_rsvps(status)
  auth = Authentication.first(:account_id => event.partner.account.id, :provider => 'facebook')
  rsvp = {}
  if auth
    graph = Koala::Facebook::GraphAPI.new(auth.credentials['token'])
    if status == 'attending' or status == 'maybe'
      rsvp = grapha.get_connections(fb_event_id, status)
    end
  end
  logger.info "rsvp = #{rsvp.to_json}"
  rsvp  
  
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
  
  def update_fb_event
    auth = Authentication.first(:account_id => event.partner.account.id, :provider => 'facebook')
    graph = Koala::Facebook::GraphAPI.new(auth.credentials['token'])
    params = {
      :name => title.to_s,
      :description => "#{description}",
      :start_time => showdate,
      :end_time => showdate+4.hours
    }
    graph.put_object("#{fb_event_id}", params)
  end
end
