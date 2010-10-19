module DiscoverOembeds
	module Oembedables
		module InstanceMethods

			def parse_oembeds fields
				self.oembeds.destroy_all
				fields.each do |f|
					if (content = self.send(f.keys.first))
						Array.wrap(f.values.first[:providers]).each do |p|
							"::DiscoverOembeds::Providers::#{p.to_s.camelize}".constantize.parse(content).each do |oembed|
								oembed.field = f.keys.first.to_s
								self.oembeds << oembed
							end
						end
					end
				end
			
			end
		
		end
	end
end