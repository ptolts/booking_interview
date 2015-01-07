class BookingController < ApplicationController
	def setup_booking_model params
		data = JSON.parse(params)
		Rails.logger.warn data.to_s
		apartment = Apartment.find(data["id"])
	    format = "%Y-%m-%dT%H:%M:%S.%L%z";
	    start_date = Date.strptime(data["start_date"], format).to_time.utc
	    end_date = Date.strptime(data["end_date"], format).to_time.utc
	    booking = Booking.new
	    booking.apartment = apartment
	    booking.start_date = start_date
	    booking.end_date = end_date
	    booking
	end		

	def check_availability
		booking = setup_booking_model params[:data]
	    render json: {price: booking.calculate_price, availability: booking.available?}
	end

	def all
		render json:Booking.all.as_json
	end

	def book
		booking = setup_booking_model params[:data]
		booking.save
		render json: {success:true}.as_json
	end
end
