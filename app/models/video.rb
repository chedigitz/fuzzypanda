class Video
  include MongoMapper::Document
  after_save :add_to_event
  after_destroy :remove_from_event
  # key <name>, <type>
  key :title, String
  key :url, String
  key :provider, String
  key :date, Date
  key :featured, Boolean
  key :event_id, ObjectId
  timestamps!

  belongs_to :video

  private
  def add_to_event
  	event = Event.find(event_id)
  	event.videos << id
  	event.save!  	
  end

  def remove_from_event
  	 Event.pull({:video_ids => id}, {:video_ids => id})
  end

end
