require 'cover_api'
require 'zazzle'
require 'collage_generator'

class KevitzController < ApplicationController
	def index

	end

	def find_covers_by_artist
		results = CoverAPI.find_covers_by_artist params[:term]
		render json: results
	end

	def buy
		collage_local_path = CollageGenerator.generate params[:covers]
		file = File.open collage_local_path
		collage = Collage.create image: file
		file.close
		File.unlink(collage_local_path)

		zazzle_url = Zazzle.get_template_product_api collage.image.url
		render json: { zazzleUrl: zazzle_url }
	end
end
