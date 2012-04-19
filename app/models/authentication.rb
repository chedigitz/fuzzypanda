class Authentication
  include MongoMapper::Document

  # key <name>, <type>
  key :provider, String
  key :uid, String
  key :info, Hash

  belongs_to :account 
  key :account_id, ObjectId
  
  timestamps!


  


end
