require_relative "../test_helper"

class ScraperTest < Test::Unit::TestCase

  def test_gathers_required_values_for_scraping
    scraper = Scraper.new(book_page_url: "https://www.amazon.com/REIGN-Tribulation-Jeffrey-McClain-Jones-ebook/dp/B00BNPFXK8")

    assert_equal "The REIGN: Out of Tribulation", scraper.target_book_title
    assert scraper.carousel_id > 0
    assert scraper.carousel_pages > 0
    assert scraper.books_per_carousel_page > 0

    # This tests the file name format including removing special characters and using an expected carousel verb
    assert_match /\.\/csv\/the_reign_out_of_tribulation_also_(bought|read|viewed)_\d{10}\.csv/, scraper.output_file_name

    scraper.driver.quit
  end

  def test_successfully_finds_books_in_the_us
    scraper = Scraper.new(book_page_url: "https://www.amazon.com/REIGN-Tribulation-Jeffrey-McClain-Jones-ebook/dp/B00BNPFXK8")
    scraper.run
    assert scraper.books_found.count > 2, "Found #{scraper.books_found.count} books which was less than expected"
  end

  def test_successfully_finds_books_in_the_uk
    scraper = Scraper.new(book_page_url: "https://www.amazon.co.uk/Sharing-Jesus-Seeing-Book-ebook/dp/B01E0EP1YG")
    scraper.run
    assert scraper.books_found.count > 2, "Found #{scraper.books_found.count} books which was less than expected"
  end

  def test_successfully_finds_books_in_australia
    scraper = Scraper.new(book_page_url: "https://www.amazon.com.au/Seeing-Jesus-Jeffrey-McClain-Jones-ebook/dp/B00D8KZH0M")
    scraper.run
    assert scraper.books_found.count > 2, "Found #{scraper.books_found.count} books which was less than expected"
  end

  def test_successfully_finds_books_in_canada
    scraper = Scraper.new(book_page_url: "https://www.amazon.ca/Sharing-Jesus-Seeing-Book-ebook/dp/B01E0EP1YG")
    scraper.run
    assert scraper.books_found.count > 2, "Found #{scraper.books_found.count} books which was less than expected"
  end
end
