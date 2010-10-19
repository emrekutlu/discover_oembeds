module DiscoverOembeds
	module Providers

		class Youtube < Base

			ENDPOINT			= 'http://www.youtube.com/oembed'
			SCHEMES				= [Regexp.new('(http:\/\/www\.youtube\.com\/watch\?v=\S+)'),Regexp.new('(http:\/\/youtu\.be\/\S+)')]
			FORMAT				= 'json'
			PARAMS				= { :maxwidth => 450 }
			THUMB_PARAMS	= { :maxheight => 75 }
			
		end

	end
end