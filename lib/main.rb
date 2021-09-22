require_relative './module_loader'

puts "======"
puts "This script will scrape a single carousel on the Amazon book listing page"
puts "selected based on order of precedence:"
puts "1. Customers who bought this item also bought"
puts "2. Customers who read this book also read"
puts "3. Customers who viewed this item also viewed"
puts "======"
puts "Enter the Amazon book page URLs to scrape (comma-separated)".cyan
print "> "

Array($stdin.gets.chomp.split(",")).each do |page_url|
  exit 0 if ["quit", "q", "exit"].include?(page_url.downcase)

  puts "Loading automated browser for web scraper..."

  scraper = Scraper.new(book_page_url: page_url.strip)

  print "Scraping "
  scraper.run { print "." }
  puts ""

  puts "Exporting to CSV: #{scraper.output_file_name}"
  CSV.open(scraper.output_file_name, "wb") do |csv|
    csv << Book::CSV_HEADERS
    scraper.books_found.each do |book|
      csv << book.as_csv_row
    end
  end

  $logger.debug("Completed scraping for URL: #{page_url}") if $logger
end

system("open ./csv")
