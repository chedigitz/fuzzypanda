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
    response['content'] = []
    response['content'][0]= { 
      "title" => self.event.title, 
      "description" => "PPV Event", 
      "price" => self.event.price,
      "image_url" => "http:\/\/www.facebook.com\/images\/gifts\/21.png"   }
    response['method'] = 'payments_get_items'
    response
  end


end


