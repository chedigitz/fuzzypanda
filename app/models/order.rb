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
    fb_credits = 0.1 
    event_price = self.event.price.to_i / fb_credits 
    response = Hash.new
    response['content'] = []
    response['content'][0]= { 
      "title" => self.event.title, 
      "description" => "an iPPV Event", 
      "price" => event_price,
      "image_url" => self.event.poster_url   }
    response['method'] = 'payments_get_items'
    response
  end


end


