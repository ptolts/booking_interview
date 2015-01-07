#encoding: UTF-8

class Price
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in collection: "Price" 

  field :start_date, type: DateTime
  field :end_date, type: DateTime
  field :price, type: Float, default: 0.0

  index({ _id:1 }, { unique: true, name:"id_index" })

  belongs_to :apartment, class_name: "Apartment", inverse_of: :prices, index: true

  def serializable_hash options = {}
    hash = super()
    hash[:id] = id
    return hash
  end  

end
