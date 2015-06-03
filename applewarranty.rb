require "net/http";
require "date"
class AppleWarranty
	attr_reader :imei
	
	def imei= value
		if (! (value =~ /^\d{15,16}$/))
			raise "InvalidImeiError"
		end
		@imei = value;
	end

	def initialize(imei = '')
		self.imei= imei if (imei != '') 
	end

	def check
		if (@imei == nil) 
			raise "NoImeiError"
		end

		#
		# GET THE APPLE RESPONSE
		#
		url = URI("https://selfsolve.apple.com/wcResults.do");
		params = {
			:sn => imei,
			:cn => '',
			:locale => '',
			:caller => '',
			:num => '292234' #no idea what is it, get the value from a browser request inspector
		}

		output = Net::HTTP.post_form(url, params);

		#
		# SCRAPE WARRANTY EXPIRATION DATE
		#
		regexp = /Estimated Expiration Date: (?<month>.+?) (?<day>\d+), (?<year>\d{4})/
		if (regexp =~ output.body) 
			result  = "%s-%02d-%s" % [Regexp.last_match[:year], Date::MONTHNAMES.index(Regexp.last_match[:month]), Regexp.last_match[:day]]
		else
			raise "OutOfWarranty"
		end
	end
end