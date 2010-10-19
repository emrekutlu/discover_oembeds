module DiscoverOembeds
	module Providers

		class Vimeo < Base

			ENDPOINT			= 'http://www.vimeo.com/api/oembed.{format}'
			SCHEMES				= [Regexp.new('(http:\/\/((www\.)?)vimeo\.com\/\d+)'), Regexp.new('(http:\/\/((www\.)?)vimeo\.com\/groups\/\S+\/videos\/\d+)')]
			FORMAT				= 'json'
			PARAMS				= { :maxwidth => 450 }
			THUMB_PARAMS	= { :maxheight => 75 }

		end
		
	end
end
