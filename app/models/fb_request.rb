class FbRequest
  include MongoMapper::Document

  # key <name>, <type>
  key :from_account_id, ObjectId
  key :event_id, ObjectId
  key :to_account_ids, Array
  key :fb_id, String
  timestamps!
end
