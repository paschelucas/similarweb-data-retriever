require 'selenium-webdriver'

class DriverManager
    def initialize
        @driver = nil
    end

    def get_driver
        if @driver.nil?
            options = Selenium::WebDriver::Options.firefox
            @driver = Selenium::WebDriver.for :firefox, options: options
        end
        return @driver
    end

    def quit_driver
        @driver&.quit
        @driver = nil
    end
end