require_relative './applewarranty'
describe AppleWarranty do 
	it "should exists" do
		AppleWarranty.new
	end

	it "#check should exists" do
		expect(AppleWarranty.method_defined?(:check)).to eq(true)
	end

	it ".imei= should raise exception when invalid imei given" do
		expect { AppleWarranty.new.imei = 'invalidimei' }.to raise_error("InvalidImeiError")
		expect { AppleWarranty.new.imei = 'Invalid358030053434523' }.to raise_error("InvalidImeiError")
		expect { AppleWarranty.new.imei = '358030053434523' }.not_to raise_error
		expect { AppleWarranty.new.imei = '3580300534345230' }.not_to raise_error
	end

	it ".new should call #imei= when called with argument" do
		expect{AppleWarranty.new("imei")}.to raise_error("InvalidImeiError")
		expect(AppleWarranty.new("358030053434523").imei).to eq("358030053434523")
	end

	it "#check should raise exception when no imei given" do
		expect{AppleWarranty.new.check}.to raise_error("NoImeiError")
	end

	it "#check should raise exception for out-of-warranty imei" do
		expect { AppleWarranty.new('013896000639712').check}.to raise_error("OutOfWarranty")
	end

	# ACHTUNG! THIS TEST WILL BE FAILED SOMEDAY!
	it "#check should return expiration date (YYYY-MM-DD) for in-warranty imei" do
		expect(AppleWarranty.new('013977000323877').check).to match(/\d{4}-\d{2}-\d{2}/)
	end
end