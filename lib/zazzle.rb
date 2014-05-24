require 'uri'
require 'active_support/core_ext/object/to_query'
require 'awesome_print'

class Zazzle

	HOST = 'http://www.zazzle.com/'
	PATH = "api/create/at-%{rf}"
	RF = '238779073096817954'

	def self.get_template_product_api(collage_url)
		# http://www.zazzle.com/api/create/at-238779073096817954?rf=238779073096817954&ax=Linkover&pd=192258280259945962&fwd=ProductPage&ed=true&tc=&ic=&t_collage_iid=
		# ap Zazzle.get_template_product_api("http://lorempixel.com/400/400")
		
		params = {
			ax: 'Linkover',
			rf: RF,
			pd: '192258280259945962',
			fwd: 'ProductPage',
			ed: true,
			tc: '',
			ic: '',
			t_collage_iid: URI.encode(collage_url)
		}

		path = PATH % {rf: RF}

		"#{HOST}/#{path}?#{params.to_query}"
	end

end
