class ApartmentController < ApplicationController
	def all
		render json:Apartment.all.as_json
	end 
end
