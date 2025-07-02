require 'open-uri'
require 'nokogiri'
#URL to fetch
puts "Welcome to Osint Scraper 00\n"
puts "Don't do anything illegal\n"
loop do #for loop but in ruby
  puts "\nWhat would you like to do with me?"
  puts "1.Scrape a URL and we show you how far the rabbit hole goes"
  puts "2. Exit and stay in wonderland"
  print "Enter your choice: "
  choice = gets.chomp.to_i #input into int
  case choice
  when 1
    puts "Going down the rabbit hole..."
    puts "Please enter the URL you want to scrape (e.g., https://valm23.github.io):"
target_url = gets.chomp #reads user input.
#Uses Open-URI to read our variable, stored as target_url and reads code.
html_content = URI.open(target_url).read
puts "So, what're we looking for? (Comma-separated, e.g., 'cybersecuity, network, analyst, baker who talked to my ex'):"
keyword_get = gets.chomp
keywords = keyword_get.split(',').map(&:strip).reject(&:empty?)
#Looking into what you put in there
puts "\n--- Keyword Search Results ---"
foundem = []
#Searching in full HTML content
html_content_lower = html_content.downcase #make it quieter, but in text

keywords.each do |keyword|
  keyword_lower = keyword.downcase #super sensitive, case sensitive. 
  if html_content_lower.include?(keyword_lower)
    foundem << keyword
  end
end

if foundem.empty?
  puts "No specified keywords found anywhere on the page."
else
  puts "We gottem: #{foundem.join(',')}"
end
puts "------------------------------------------"

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

puts "\nWould you like to save the output to a file? (yes/no)"
decision = gets.chomp.downcase

if decision == 'yes' || decision =='y' 
  puts "Enter filename (e.g., 'report.txt', 'homework_folder', 'catgirlAIphotos'):"
  filename = gets.chomp
  begin #storing other gubbins from earlier
    OGOutput = $stdout
    #writing stuff down
    $stdout = File.open(filename, 'w')
    puts "\n--- Keyword Search Results ---"
if foundem.empty?
  puts "No specified keywords found anywhere on the page."
else
  puts "We gottem: #{foundem.join(',')}"
end
puts "------------------------------------------"
  puts "--Full Text Block --"
  puts full_text_block
  puts "-------------------"
print_horizontal_line(column_width)
puts '|'+ header.join('|') + '|'
print_horizontal_line(column_width)
experience_data.each do | job_entry|
  rows = job_entry.each_with_index.map do |value, index|
    value.ljust(column_width[index])
  end
  puts '|' + rows.join('|') +'|'
end
print_horizontal_line(column_width)
rescue => e
  puts "Error Saving File (or Roxy broke something): #{e.message}"
ensure
  #Saving output even if it dies.
  $stdout = OGOutput
  puts "Output saved to #{filename}"
  end
end
  when 2
    puts "Exiting. The scrape has healed..."
    break #exit
  else
    puts "Invalid choice. This decision will have consequences."
  end
end 
