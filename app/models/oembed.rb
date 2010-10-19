class Oembed < ActiveRecord::Base
	
	belongs_to	:resource, :polymorphic => true	
	validates_presence_of	:kind, :version

	def photo?
		kind.eql? 'photo'
	end

	def video?
		kind.eql? 'video'
	end

end