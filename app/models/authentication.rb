class Authentication
  include MongoMapper::Document

  # key <name>, <type>
  key :provider, String
  key :uid, String
  key :profile_dump, Array

  belongs_to :account 
  key :account_id, ObjectId
  
  timestamps!
end
