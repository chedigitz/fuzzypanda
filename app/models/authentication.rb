class Authentication
  include MongoMapper::Document

  # key <name>, <type>
  key :provider, String
  key :uid, String
  key :info, Hash
  key :credentials, Hash


  belongs_to :account 
  key :account_id, ObjectId
  
  timestamps!


  


end
