require 'benchmark'
require 'cover_api'
require 'zazzle'
require 'collage_image_generator'

class KevitzController < ApplicationController
	def index
	end

	def find_covers_by_artist
		results = CoverAPI.find_covers_by_artist params[:term]
		render json: results
	end

	def buy
    collage_local_path = nil
    time = Benchmark.realtime do
      collage_local_path = CollageImageGenerator.generate params[:covers]
    end
    puts "CollageImageGenerator took #{time} seconds"
    collage = Collage.create_from_local_image(collage_local_path)
    File.unlink(collage_local_path)
		zazzle_url = Zazzle.get_template_product_api collage.image.url
		render json: { zazzleUrl: zazzle_url }
	end
end
