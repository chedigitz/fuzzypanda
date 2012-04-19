class Assigment
  include MongoMapper::Document
  after_destroy :remove_from_callsheets

  # key <name>, <type>
  key :task, String
  key :dayrate, Float
  key :settled, Boolean, :default => "false"
  timestamps!

  #associations
  belongs_to :callsheet
  key :callsheet_id, ObjectId

  belongs_to :account
  key :account_id, ObjectId

  def add_to_callsheet(callsheet)
    callsheet.assigments << self
    callsheet.save!    
  end


  private
  def remove_from_callsheets
     Callsheet.pull({:assigment_ids => id}, {:assigment_ids => id})
  end 

  
 

end