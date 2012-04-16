class Crewmember
  include MongoMapper::Document

  # key <name>, <type>
  key :role, String
  key :note, String
  key :account_id, ObjectId
  key :callsheet_id, ObjectId
  timestamps!



end
