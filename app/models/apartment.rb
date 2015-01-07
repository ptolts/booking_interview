#encoding: UTF-8

class Apartment
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in collection: "Apartment" 

  field :cleaning_fee, type: Float, default: 80.0
  field :currency, type: String, default: "CAN"

  index({ _id:1 }, { unique: true, name:"id_index" })

  has_many :bookings, class_name: "Booking", inverse_of: :apartment
  has_many :prices, class_name: "Price", inverse_of: :apartment
  has_many :event_prices, class_name: "EventPrice", inverse_of: :apartment

  def serializable_hash options = {}
    hash = super()
    hash[:id] = id
    return hash
  end

  def self.seed
    (0..14).each do |i|
      apartment = Apartment.create

      #Random Cleaning Price
      if Random.rand(3) == 0
        apartment.cleaning_fee = 120.0
      end

      #Random Currency
      if Random.rand(2) == 0
        apartment.currency = "US"
      end           

      (Date.new(2015, 01, 01)..Date.new(2015, 12, 01)).select{|d| d.day == 1}.each do |month|
        sun_to_thur = 90#Random.rand(300)
        fri_to_sat = 110#Random.rand(300)
        # There is probably a better way of dealing with these price ranges.
        # I designed the prices to be more versatile, but this will do for now.
        (month..month.next_month.prev_day).each do |day|
          if day.sunday? or day.monday? or day.tuesday? or day.wednesday? or day.thursday?
            price = Price.new(start_date: day.in_time_zone.to_time.utc, end_date: day.in_time_zone.to_time.utc, price: sun_to_thur)
          else
            price = Price.new(start_date: day.in_time_zone.to_time.utc, end_date: day.in_time_zone.to_time.utc, price: fri_to_sat)
          end
          #random_availability 
          if Random.rand(3) == 0
            price.price = 0.0
          end
          price.apartment = apartment
          price.save
        end
      end
    end
  end

end
