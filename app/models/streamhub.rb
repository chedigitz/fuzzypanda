class Streamhub
  include MongoMapper::Document
  after_save :add_to_event
  after_destroy :remove_from_event
  # key <name>, <type>
  key :url, String
  key :type, String
  key :date, Time
  key :endtime, Time
  key :price, Float
  key :mobile, Boolean
  key :facebook, Boolean
  key :thumbnails, Array
  key :fms_url, String
  key :mobile_url, String
  key :fm_resource, String
  key :server_dns, String
  timestamps!

  belongs_to :event
  key :event_id, ObjectId

  private
  def add_to_event
    event = Event.find(event_id)
    event.streamhubs << id
    event.save!

  end

  def remove_from_event
    Event.pull({:streamhub_ids => id}, {:streamhub_ids => id})
    
  end

end
