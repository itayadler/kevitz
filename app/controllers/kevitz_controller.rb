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
    zazzle_url = nil
    type = params[:type] || "poster"
    width = params[:width] || 40
    height = params[:height] || 40
    CollageImageGenerator.generate params[:covers] do |collage_local_path|
      collage = Collage.create_from_local_image(collage_local_path)
      product_id = zazzle_product_id(type, width, height)
      zazzle_url = Zazzle.get_template_product_api(ZAZZLE.store_id,, product_id, collage.image.url)
    end
    puts "Final ZazzleURL: #{zazzle_url}"
		render json: { zazzleUrl: zazzle_url }
	end

  private

  def zazzle_product_id(type, width, height)
    ZAZZLE.products.find do |product_id, metadata|
      metadata["type"] == type && 
      metadata["width"] == width &&
      metadata["height"] == height
    end.try(:[], 0)
  end
end
