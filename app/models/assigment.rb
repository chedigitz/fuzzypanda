class Assigment
  include MongoMapper::Document

  # key <name>, <type>
  key :task, String
  key :dayrate, Float
  timestamps!

  #associations
  belongs_to :callsheet
  key :callsheet_id, ObjectId

  belongs_to :account
  key :account_id, ObjectId
end
