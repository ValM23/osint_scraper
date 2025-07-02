require 'open-uri'
require 'nokogiri'
#URL to fetch
puts "Welcome to Osint Scraper 00\n"
puts "Don't do anything illegal\n"
puts "Please enter the URL you want to scrape (e.g., https://valm23.github.io):"
target_url = gets.chomp #reads user input.
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
  puts "-------------------"
else
  puts "Could not find the target tag, try again."
end

experience_data = full_text_block.scan(/company = "(.*?)"\n.*?role = "(.*?)"\n.*?dates = "(.*?)"/m)
#Time to build a table from Ikea....but with legs made of data 
headers = ["Company", "Role", "Dates"]

#Init Width and lengths by checking the length of the data/headers
column_width = headers.map(&:length)
#^ Shorthand courtesy of Gemini-Sensei
experience_data.each do |job_entry|
  job_entry.each_with_index do |value, index|
    if value.length > column_width[index]
      column_width[index] = value.length
    end
  end
end
#Cushion for data pushin
column_width = column_width.map { |width| width + 2 }
puts "Here's how thicc it is: #{column_width.inspect}"
#Here's how we're gonna format this
def print_horizontal_line(column_width)
  lines = column_width.map { |width| '-' * width }
  puts '+' + lines.join('+') + '+'
end
print_horizontal_line(column_width)
header = headers.each_with_index.map do |header, index|
  header.ljust(column_width[index])
end
puts '|' + header.join('|') + '|'
print_horizontal_line(column_width)

experience_data.each do |job_entry|
  rows = job_entry.each_with_index.map do |value, index|
    value.ljust(column_width[index])
  end
  puts '|' + rows.join('|') + '|'
end
print_horizontal_line(column_width)