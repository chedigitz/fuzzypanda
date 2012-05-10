class Order
  include MongoMapper::Document

  # key <name>, <type>
  key :account_id, ObjectId
  key :event_id, ObjectId
  key :pay_provider, String
  key :token, String
  key :status, String
  key :fb_order_id, String
  timestamps!

  belongs_to :account
  belongs_to :event

  def fb_item_info
    #creates a dialog 
    response = Hash.new
    response['content']= { 
      "title" => self.event.title, 
      "description" => "PPV Event", 
      "price" => self.event.price,
      "image_url" => self.event.poster_url   }
    response.to_json
  end


end


