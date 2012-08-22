class Stream
  include MongoMapper::Document

  # key <name>, <type>
  key :url, String
  key :name, String
  key :type, String
  key :date, Date
  key :timend, Date
  key :price, Float
  key :mobile, Boolean
  key :facebook, Boolean
  key :thumbnails, Array

  timestamps!

  belongs_to :event
end
