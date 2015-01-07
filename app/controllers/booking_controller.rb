class BookingController < ApplicationController
	def setup_booking_model params
		data = JSON.parse(params)
		apartment = Apartment.find(data["id"])
	    format = "%Y-%m-%d"
	    start_date = DateTime.strptime(data["start_date"], format).in_time_zone
	    end_date = DateTime.strptime(data["end_date"], format).in_time_zone
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
