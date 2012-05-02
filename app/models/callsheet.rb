class Callsheet
  include MongoMapper::Document
  
  # key <name>, <type>
  key :call_time, Time
  key :notes, String
  key :assigment_ids, Array,  :typecast => 'ObjectId'
  key :account_ids, Array,  :typecast => 'ObjectId'

  many :accounts, :in => :account_ids
  many :assigments, :in => :assigment_ids 
  belongs_to :event
  key :event_id, ObjectId
  
 

  timestamps!
  
  
  def available_crew
    #retrieves all crew 
    crew =  Account.all(:role => "crew")
    booked = self.assigments
    #if there is crew assigments already only returned the ones not assigned
 
    if self.assigments 
      #remove booked crew memebers from list 
      booked.each do |b|
        logger.info "b id = #{b.id}"
        crew.delete_if {|c| c.id == b.account_id }
      end 
      #set remaining creww to return value 
      available = crew 
      logger.info "this is what available is #{available.to_json}"

    else
       available = crew
    end
    available    
  end
  

end
