class Callsheet
  include MongoMapper::Document
  
  # key <name>, <type>
  key :call_time, Time
  key :notes, String
  
  belongs_to :event
  key :event_id, ObjectId
  
  many :assigments

  timestamps!
  
end
