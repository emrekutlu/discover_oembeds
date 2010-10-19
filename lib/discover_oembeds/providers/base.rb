require 'httparty'

module DiscoverOembeds
	module Providers

		class Base
			
			include HTTParty

			DEFAULTS = [:youtube, :vimeo, :flickr]

			#ENDPOINT and SCHEMES constants must be implemented
			#FORMAT is optional, default is JSON
			#
			#ENDPOINT = 'http://www.youtube.com/oembed'
			#SCHEMES	= Regexp.new('(http:\/\/www\.youtube\.com\/watch\?v=\S+)')
			#FORMAT		= 'json'
			#
			#SCHEMES constant can be an array
			#

			class << self

				def endpoint
					if self.const_defined? 'ENDPOINT'
						self.send :const_get, 'ENDPOINT'
					else
						raise_unimplemented_error "ENDPOINT constant must be implemented"
					end
				end

				def schemes
					if self.const_defined? 'SCHEMES'
						Array.wrap self.send(:const_get, 'SCHEMES')
					else
						raise_unimplemented_error "SCHEMES constant must be implemented"
					end
				end

				def format
					if self.const_defined? 'FORMAT'
						self.send :const_get, 'FORMAT'
					else
						'json'
					end
				end

				def params
					self.const_defined?('PARAMS') ? self.send(:const_get,'PARAMS') : nil
				end

				def thumb_params
					self.const_defined?('THUMB_PARAMS') ? self.send(:const_get,'THUMB_PARAMS') : nil
				end

				#returns an array of Oembed models
				#Makes two oembed requests. One for original resource (video, photo), and one for thumbnail.
				#The reason of this is to get different width and height for thumbnail and original resource.
				def parse content
					oembeds = []
					schemes.each do |r|
						content.scan(r).each do |link|
							link = link.first
							response = self.get get_url(link)
							if response.code.eql? 200
								hash = if self.format.eql? 'json'
									response.parsed_response
								else
									response.parsed_response['oembed']
								end

								#data for original resource
								oembed = Oembed.new(
									:kind							=> hash['type'],
									:version					=> hash['version'],
									:title						=> hash['title'],
									:author_name			=> hash['author_name'],
									:author_url				=> hash['author_url'],
									:provider_name		=> hash['provider_name'],
									:provider_url			=> hash['provider_url'],
									:cache_age				=> hash['cache_age'],
									:thumbnail_url		=> hash['thumbnail_url'],
									:thumbnail_width	=> hash['thumbnail_width'],
									:thumbnail_height	=> hash['thumbnail_height'],
									:url							=> hash['url'],
									:html							=> hash['html'],
									:width						=> hash['width'],
									:height						=> hash['height'],
									:href							=> link
								)
								
								#data for thumbnail
								if thumb_params									
									response = self.get get_url(link, :thumbnail => true)
									if response.code.eql? 200
										hash = if self.format.eql? 'json'
											response.parsed_response
										else
											response.parsed_response['oembed']
										end
										oembed.thumbnail_url		= hash['thumbnail_url']
										oembed.thumbnail_width	= hash['thumbnail_width']
										oembed.thumbnail_height	= hash['thumbnail_height']
									end
								end

								oembeds << oembed
							end

						end
					end
					oembeds
				end

				private

				def get_url url, opts = {}
					opts.reverse_merge! :thumbnail => false

					endpoint = if self.endpoint.include? '{format}'
						self.endpoint.gsub(/\{format\}/i, format) + "?url=#{url}"
					else
						self.endpoint  + "?url=#{url}&format=#{format}"
					end
					params = opts[:thumbnail] ? self.thumb_params : self.params
					params.try :each_pair do |k, v|
						endpoint.concat "&#{k.to_s}=#{v.to_s}"
					end
					endpoint
				end

				def raise_unimplemented_error msg
					raise ::DiscoverOembeds::Errors::UnimplementedMethod, msg
				end

			end
			
		end
		
	end
end