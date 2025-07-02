require 'open-uri'
require 'nokogiri'
#URL to fetch, using portfolio for illustrative purposes
target_url = "https://valm23.github.io"
#Uses Open-URI to read our variable, stored as target_url and reads code.
html_content = URI.open(target_url).read
doc = Nokogiri::HTML(html_content)
#since we have the source code for this, inspected element to pairdown
creds = doc.css('#credentials')
#digging specifically in this id
pre_tag = creds.css('pre.text-emerald-400')
#finding it in an array
if pre_tag.any?
  full_text_block = pre_tag.first.text
  puts "--Full Text Block --"
  puts full_text_block
  puts "--------------------"
else
  puts "Could not find the target tag, try again."
end

experience_data = full_text_block.scan(/company = "(.*?)"\n.*?role = "(.*?)"\n.*?dates = "(.*?)"/m)
puts 
