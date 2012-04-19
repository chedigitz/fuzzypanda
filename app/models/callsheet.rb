class Callsheet
  include MongoMapper::Document
  
  # key <name>, <type>
  key :call_time, Time
  key :notes, String
  key :assigment_ids, Array, :index => true, :typecast => 'ObjectId'
  key :account_ids, Array, :index => true, :typecast => 'ObjectId'

  many :accounts, :in => :account_ids
  many :assigments, :in => :assigment_ids 
  belongs_to :event
  key :event_id, ObjectId
  
 

  timestamps!
  
  

  

end
