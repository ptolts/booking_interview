#encoding: UTF-8

class EventPrice
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in collection: "EventPrice" 

  field :start_date, type: DateTime
  field :end_date, type: DateTime
  field :price, type: Float, default: 0.0

  index({ _id:1 }, { unique: true, name:"id_index" })

  belongs_to :apartment, class_name: "Apartment", inverse_of: :event_prices, index: true

  def serializable_hash options = {}
    hash = super()
    hash[:id] = id
    return hash
  end  

end
