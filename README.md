# Apple warranty scraper
Fetch warranty status of Apple device by it's IMEI code

## Console usage:

`ruby consolecmd.rb IMEI`

## Usage in a code:

`AppleWarranty.new('IMEI').check`

gives expiration date in a format of YYYY-MM-DD or raises "OutOfWarranty" 
