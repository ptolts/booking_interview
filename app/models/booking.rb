#encoding: UTF-8

class Booking
  include Mongoid::Document
  include Mongoid::Timestamps
  store_in collection: "Booking"

  field :start_date, type: DateTime
  field :end_date, type: DateTime
  field :price, type: Float, default: 0.0

  index({ _id:1 }, { unique: true, name:"id_index" })

  belongs_to :apartment, class_name: "Apartment", inverse_of: :bookings, index: true

  before_save :calculate_price

  def serializable_hash options = {}
    hash = super()
    hash[:id] = id
    return hash
  end

  def available?
    return false if end_date < start_date
    return false if booked?
    price = calculate_price
    return false if price == 0.0 # No price found in database, so the apartment isnt available.
    return true
  end

  def booked?
    return true if apartment.bookings.where(:start_date.lte => start_date, :end_date.gte => start_date).count > 0
    return true if apartment.bookings.where(:start_date.lte => end_date, :end_date.gte => end_date).count > 0
    return false
  end

  def calculate_price
    return if price != 0.0
    total_price = 0.0
    (start_date..end_date).each do |date|
      price = apartment.event_prices.where(:start_date.lte => date, :end_date.gte => date).first
      price ||= apartment.prices.where(:start_date.lte => date, :end_date.gte => date).first
      Rails.logger.warn "Total Price: #{total_price} Price For Date [#{date.to_s}] => #{price.price}" if price
      total_price += price.price if price
    end
    self.price = total_price
    return total_price
  end
end
