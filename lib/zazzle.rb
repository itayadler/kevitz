require 'uri'
require 'active_support/core_ext/object/to_query'
require 'awesome_print'

class Zazzle

	HOST = 'http://www.zazzle.com/'
	PATH = "api/create/at-%{product_id}"

	def self.get_template_product_api(collage_url, product_id = '238779073096817954')
		params = {
			ax: 'Linkover',
			rf: product_id,
			pd: '192869976986838675',
			fwd: 'ProductPage',
			ed: true,
			tc: '',
			ic: '',
			t_collage_iid: URI.encode(collage_url)
		}

		path = PATH % {product_id: product_id}

		"#{HOST}/#{path}?#{params.to_query}"
		# "#{HOST}?rf=238779073096817954&ax=Linkover&pd=192869976986838675&fwd=ProductPage&ed=true&tc=&ic=&t_collage_iid=#{URI.encode collage_url}"
	end

end

ap Zazzle.get_template_product_api("http://lorempixel.com/400/400")