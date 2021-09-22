class Scraper
  SPECIAL_CHARACTERS = /[:'"\/\\.$,?!]/.freeze

  WINDOW_WIDTH = 1200.freeze
  WINDOW_HEIGHT = 800.freeze
  SLEEP_SECONDS = 1.2.freeze
  DOM_WAIT_TIMEOUT_SECONDS = 10.freeze

  attr_reader :book_page_url, :target_book_title, :carousel_id, :next_page_button,
              :carousel_pages, :books_per_carousel_page, :books_found, :driver

  def initialize(book_page_url:)
    @books_found = []
    @book_page_url = book_page_url

    start_driver
    validate_required_configuration_is_present
  end

  def run
    carousel_pages.times do
      (1..books_per_carousel_page).each do |card_number|
        book_element_text = driver
          .find_element(
            :css,
            "#anonCarousel#{carousel_id} > ol > li:nth-child(#{card_number})"
          )
          .text
          .split("\n")

        next if book_element_text[0].nil?

        books_found << Book.new(
          title: book_element_text[0],
          author: book_element_text[1]
        )
      end
      next_page_button.click
      # === Execute CLI tracking block or callback after each page is done ===
      yield if block_given?
      # === Allow JS to load for next carousel page ===
      sleep SLEEP_SECONDS
    end
    driver.quit
  end

  def output_file_name
    @output_file_name ||= "./csv/#{filename_safe_target_book_title}_also_#{carousel_verb}_#{Time.now.utc.to_i}.csv"
  end

  private

  def start_driver
    raise "book_page_url is required" if book_page_url.empty?
    service = Selenium::WebDriver::Service.chrome(path: "bin/chromedriver")
    driver_options = Selenium::WebDriver::Chrome::Options.new(binary: "bin/chromedriver")
    @driver = Selenium::WebDriver.for(:chrome, service: service)
    driver.manage.window.resize_to(WINDOW_WIDTH, WINDOW_HEIGHT)
    driver.manage.timeouts.implicit_wait = DOM_WAIT_TIMEOUT_SECONDS
    driver.get(book_page_url)

    if book_page_url.include?("www.amazon.co.uk")
      # === Accept cookies in the UK ===
      driver.find_element(:css, "#sp-cc-accept").click
    end

    # === NOTE ABOUT UI VERSIONS: ===
    # Some versions of the UI do not have a section titled 'Customers who bought
    # this item also bought', in these cases, first fall back to 'Customers who
    # read this book also read', then finally 'Customers who viewed this item
    # also viewed'. So far, at least one of these three carousels has existed
    # on every UI version this script has been tested against.

    customers_who_bought_this_book_parent = "//*[text()='Customers who bought this item also bought']/../../.."
    customers_who_read_this_book_parent = "//*[text()='Customers who read this book also read']/../../.."
    customers_who_viewed_this_item_parent = "//*[text()='Customers who viewed this item also viewed']/../../.."
    carousel_header_parent = driver.find_element(:xpath, "#{customers_who_bought_this_book_parent} | #{customers_who_read_this_book_parent} | #{customers_who_viewed_this_item_parent}")

    # === Navigate down to the carousel in the browser to trigger the JS to load ===
    customers_who_bought_this_book_header = "//*[text()='Customers who bought this item also bought']"
    customers_who_read_this_book_header = "//*[text()='Customers who read this book also read']"
    customers_who_viewed_this_item_header = "//*[text()='Customers who viewed this item also viewed']"
    driver.find_element(:xpath, "#{customers_who_bought_this_book_header} | #{customers_who_read_this_book_header} | #{customers_who_viewed_this_item_header}").click

    # === Load values required for scraping ===
    @target_book_title = driver.find_element(:css, "#productTitle").text
    @carousel_id = carousel_header_parent.find_element(:xpath, ".//*[@class='a-carousel-viewport']").attribute("id").gsub("anonCarousel", "").to_i
    # This will be 'bought', 'read', or 'viewed'
    @carousel_verb = carousel_header_parent.text.split("\n").first.split.last
    @next_page_button = carousel_header_parent.find_element(:css, ".a-carousel-goto-nextpage")
    @carousel_pages = carousel_header_parent.find_element(:xpath, ".//*[@class='a-carousel-page-max']").text.to_i
    @books_per_carousel_page = carousel_header_parent.find_elements(:xpath, ".//*[@class='a-carousel-card']").count
  end

  def validate_required_configuration_is_present
    raise "book_page_url is required" if book_page_url.empty?
    raise "target_book_title is required" if target_book_title.empty?
    raise "carousel_id is required" if carousel_id.to_s.empty? || carousel_id.zero?
    raise "carousel_verb is required" if carousel_verb.empty?
    # if next_page_button is not found selenium will raise Selenium::WebDriver::Error::NoSuchElementError
    raise "carousel_pages is required" if carousel_pages.to_s.empty? || carousel_pages.zero?
    raise "books_per_carousel_page is required" if books_per_carousel_page.to_s.empty? || books_per_carousel_page.zero?
  end

  def carousel_verb
    @carousel_verb
  end

  def filename_safe_target_book_title
    target_book_title.gsub(SPECIAL_CHARACTERS, "").split.join("_").downcase
  end
end
