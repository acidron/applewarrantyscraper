#!/usr/bin/ruby
require "net/http";
require "date"

#
# CHECK IMEI
#
imei = ARGV[0]
if (imei == nil || imei.length == 0 || imei == 'help') 
	puts "command usage:\n\n %s IMEI\n" % File.basename(__FILE__)
	puts 
	puts "Exit codes are:"
	puts "0 - the device is in warranty, check the response message to get expiration date in YYYY-MM-DD format"
	puts "1 - invalid imei given"
	puts "2 - Apple service is not responding"
	puts "3 - the device is out of warranty"
	exit
end

if (! (imei =~ /\d{15,16}/))
	print "Invalid IMEI given"
	exit(1)
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

begin
	output = Net::HTTP.post_form(url, params);
rescue SocketError
	puts $!
	exit(2)
end

#
# SCRAPE WARRANTY EXPIRATION DATE
#
regexp = /Estimated Expiration Date: (?<month>.+?) (?<day>\d+), (?<year>\d{4})/;
if (regexp =~ output.body) 
	print "In warranty till "
	print Regexp.last_match[:year]
	print "-"
	print "%02d" % Date::MONTHNAMES.index(Regexp.last_match[:month])
	print "-"
	print Regexp.last_match[:day]
else
	print "Out of warranty"
	exit(3)
end