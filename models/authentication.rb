class Authentication
  include MongoMapper::EmbeddedDocument

  # key <name>, <type>
  key :provider, String
  key :uid, String
  timestamps!
end
