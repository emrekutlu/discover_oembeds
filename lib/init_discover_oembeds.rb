class ActiveRecord::Base

  def self.discover_oembeds *fields
		
		fields = [:content] if fields.empty?
		fields.flatten!
		fields.each_index do |i|
			fields[i] = { fields[i].to_sym => { :providers => ::DiscoverOembeds::Providers::Base::DEFAULTS } } unless fields[i].kind_of?(Hash)
		end


		has_many :oembeds, :as => :resource, :dependent => :destroy do
			fields.each do |f|
				key = f.keys.first
				define_method key do
					with_scope :find => { :conditions => { :field => key.to_s } } do
						all
					end
				end
			end
		end

		after_save { |model| model.parse_oembeds fields }

    include DiscoverOembeds::Oembedables::InstanceMethods
  end
	
end