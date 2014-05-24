load "#{Rails.root}/lib/cover_api.rb" 
# require 'cover_api'


class KevitzController < ApplicationController
	def index

	end

	def find_covers_by_artist
		results = CoverAPI.find_covers_by_artist params[:term]
		render json: results
	end
end
