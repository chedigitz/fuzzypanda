class Scene
  include MongoMapper::Document
  after_save :add_to_event
  after_destroy :remove_from_event
  # key <name>, <type>
  key :event_id, String
  key :actor_ids, ObjectId
  key :image_ids, ObjectId
  timestamps!

  many :actors, :in => :actor_ids 
  many :images, :in => :image_ids
  belongs_to :event
 
 def add_actor(actor)
   self.actors << actor 
 end
 
 def add_image(image)
 	self.images << image 
 end
 
 private
  def add_to_event
  	
    event = Event.find(event_id)
  	event.videos << self
  	event.save!  	
  end

  def remove_from_event
  	 Event.pull({:scene_ids => id}, {:scene_ids => id})
  end


end
