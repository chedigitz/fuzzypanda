class Partner
  include MongoMapper::Document

  # key <name>, <type>
  key :name, String
  key :website, String
  key :account_id, ObjectId
  key :event_ids, Array, :typecast => "ObjectId"
  timestamps!

 many :events, :in => :event_ids


end
