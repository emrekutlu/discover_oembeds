module DiscoverOembeds
	module Providers

		class Flickr < Base

			ENDPOINT	= 'http://www.flickr.com/services/oembed/'
			SCHEMES		= [Regexp.new('(http:\/\/www\.flickr\.com\/photos\/\S+)')]
			FORMAT		= 'json'
			PARAMS		= { :maxwidth => 500 }

		end

	end
end