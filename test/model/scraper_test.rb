require_relative "../test_helper"

class ScraperTest < Test::Unit::TestCase

  def test_gathers_required_values_for_scraping
    scraper = Scraper.new(book_page_url: "https://www.amazon.com/REIGN-Tribulation-Jeffrey-McClain-Jones-ebook/dp/B00BNPFXK8/ref=sr_1_1_sspa?dchild=1&keywords=jeffrey+mcclain+jones&qid=1627886065&sr=8-1-spons&psc=1&spLa=ZW5jcnlwdGVkUXVhbGlmaWVyPUExRkpXQ0lZTkhFRlhVJmVuY3J5cHRlZElkPUEwODYxMjIyMTNQSEE3TzhPRzBRNCZlbmNyeXB0ZWRBZElkPUEwMzEzODgzTTVTWTBCWkJORlYxJndpZGdldE5hbWU9c3BfYXRmJmFjdGlvbj1jbGlja1JlZGlyZWN0JmRvTm90TG9nQ2xpY2s9dHJ1ZQ==")

    assert_equal "The REIGN: Out of Tribulation", scraper.target_book_title
    assert scraper.carousel_id > 0
    assert scraper.carousel_pages > 0
    assert scraper.books_per_carousel_page > 0

    # This tests the file name format including removing special characters and using an expected carousel verb
    assert_match /\.\/csv\/the_reign_out_of_tribulation_also_(bought|read|viewed)_\d{10}\.csv/, scraper.output_file_name

    scraper.driver.quit
  end

  def test_successfully_finds_books_in_the_us
    scraper = Scraper.new(book_page_url: "https://www.amazon.com/REIGN-Tribulation-Jeffrey-McClain-Jones-ebook/dp/B00BNPFXK8/ref=sr_1_1_sspa?dchild=1&keywords=jeffrey+mcclain+jones&qid=1627886065&sr=8-1-spons&psc=1&spLa=ZW5jcnlwdGVkUXVhbGlmaWVyPUExRkpXQ0lZTkhFRlhVJmVuY3J5cHRlZElkPUEwODYxMjIyMTNQSEE3TzhPRzBRNCZlbmNyeXB0ZWRBZElkPUEwMzEzODgzTTVTWTBCWkJORlYxJndpZGdldE5hbWU9c3BfYXRmJmFjdGlvbj1jbGlja1JlZGlyZWN0JmRvTm90TG9nQ2xpY2s9dHJ1ZQ==")
    scraper.run
    assert scraper.books_found.count > 10
  end

  def test_successfully_finds_books_in_the_uk
    scraper = Scraper.new(book_page_url: "https://www.amazon.co.uk/Seeing-Jesus-Jeffrey-McClain-Jones-ebook/dp/B00D8KZH0M/ref=sr_1_1?dchild=1&keywords=seeing+jesus&qid=1627944060&sr=8-1")
    scraper.run
    assert scraper.books_found.count > 10
  end

  def test_successfully_finds_books_in_australia
    scraper = Scraper.new(book_page_url: "https://www.amazon.com.au/Seeing-Jesus-Jeffrey-McClain-Jones-ebook/dp/B00D8KZH0M/ref=sr_1_2?dchild=1&keywords=seeing+jesus&qid=1627944663&sr=8-2")
    scraper.run
    assert scraper.books_found.count > 10
  end

  def test_successfully_finds_books_in_canada
    scraper = Scraper.new(book_page_url: "https://www.amazon.ca/Seeing-Jesus-Jeffrey-McClain-Jones-ebook/dp/B00D8KZH0M/ref=sr_1_1?dchild=1&keywords=seeing+jesus&qid=1627944583&sr=8-1")
    scraper.run
    assert scraper.books_found.count > 10
  end
end
