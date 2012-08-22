class Image
  include MongoMapper::EmbeddedDocument

  # key <name>, <type>
  key :type, String
  key :url, String
  timestamps!
end
