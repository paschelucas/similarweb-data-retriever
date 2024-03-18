require 'dotenv'
require_relative '../../config/DriverManager'
require_relative '../../utils/extract_data'
require_relative '../scraper/scraper.config'
Dotenv.load

configure do
    set :driver_manager, DriverManager.new
end

module WebsiteScraper
  def self.fetch_website_data(encoded_url)
    driver = DriverManager.new.get_driver
    base_url = WebsiteScraperConfig::BASE_SIMILARWEB_URL

    driver.get(base_url)
    website_data = {
      'Company' => nil,
      'Year Founded' => nil,
      'Employees' => nil,
      'HQ' => nil,
      'Annual Revenue' => nil,
      'Industry' => nil,
      'Total Visits' => nil,
      'Bounce Rate' => nil,
      'Pages per Visit' => nil,
      'Last Month Change' => nil,
      'Avg Visit Duration' => nil,
      'Global Rank' => nil,
      'Country Rank' => nil,
      'Category Rank' => nil
    }

    close_popup_button = driver.find_element(class: 'app-banner__dismiss-button')
    close_popup_button.click if close_popup_button
    driver.find_elements(tag_name: 'input')[1].send_keys(encoded_url)

    buttons = driver.find_elements(tag_name: 'button')
    search_button = buttons.filter { |button| button.text == 'Search' }[0]
    search_button.click

    info_boxes = driver.find_elements(class: 'engagement-list__item')
    extract_data(info_boxes, website_data)

    info_card_rows = driver.find_elements(class: 'app-company-info__row')
    extract_data(info_card_rows, website_data)

    info_ranking_boxes = driver.find_elements(class: 'wa-rank-list__item')
    extract_data(info_ranking_boxes, website_data)

    driver.quit
    website_data
  end
end
