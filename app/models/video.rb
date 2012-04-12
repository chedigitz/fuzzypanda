class Video
  include MongoMapper::EmbeddedDocument

  # key <name>, <type>
  key :title, String
  key :url, String
  key :provider, String
  key :date, Date
  key :featured, Boolean
  timestamps!
end
