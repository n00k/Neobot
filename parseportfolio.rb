#!/usr/local/bin/ruby
require 'rubygems'
require 'hpricot'
require 'cgi'

source =  "portfolio.html"
#threshold = 300.0 # percent increase
threshold = ENV['stockthresh'].to_i
postdata = ""
selling = false

htmldoc = Hpricot.parse(File.read(source))
frm=(htmldoc/:form).detect{|f| f.attributes['action'] == "process_stockmarket.phtml"}
#frm.children.find_all{ |e| e.class != Hpricot::Text and e.name == "input" }

frm.get_elements_by_tag_name("input").each do |el|
	case el.attributes['type'].upcase
	when "TEXT":
		change = el.parent.previous_sibling.to_plain_text.to_f
	     sharesel = el.parent.previous_sibling.previous_sibling.previous_sibling.previous_sibling.previous_sibling
		sharesel = sharesel.previous_sibling if sharesel.previous_sibling
	     shares = sharesel.to_plain_text.gsub(",","").to_i
		postdata += '&' if postdata.length > 0
		postdata += CGI::escape(el.attributes['name']) + "="
		if change >= threshold
			selling = true
			puts "#{el.attributes['name']} #{shares} shares #{change}% change"
			postdata += shares.to_s
		end
	when "HIDDEN":
		postdata += '&' if postdata.length > 0
		postdata += CGI::escape(el.attributes['name'])  
		postdata += "=" + CGI::escape(el.attributes['value']) if el.attributes['value']
	when "SUBMIT":
		if el.attributes['name']
			postdata += '&' if postdata.length > 0
			postdata += CGI::escape(el.attributes['name'])
			postdata += "=" + CGI::escape(el.attributes['value']) if el.attributes['value']
		end
	end
end

if selling
	exec "/usr/local/bin/wget " +
	 "--post-data '#{postdata}' " +
	 "--referer='http://www.neopets.com/stockmarket.phtml?type=portfolio' " +
	 "--load-cookies #{ENV['cookiefile']} " +
	 "--save-cookies #{ENV['cookiefile']} " +
	 "--keep-session-cookies " +
	 "-U 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.13) Gecko/20080311 Firefox/2.0.0.13' " +
	 "'http://www.neopets.com/process_stockmarket.phtml' " +
	 "-O - | grep -i sold 2>/dev/null"
else
	puts "No stocks met #{threshold}% threshold."
end
