require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(open('http://www.cookpad.com'))

doc.xpath('//div[@id="past_featured_content"]//li/a').each do |item|
  puts "#{item.text.chomp} - #{item.attributes['href'].text}"
end

puts

doc.css('div#past_featured_content li a').each do |item|
  puts "#{item.text.chomp} - #{item.attributes['href'].text}"
end
