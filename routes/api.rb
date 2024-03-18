require 'selenium-webdriver'
require 'securerandom'
require 'dotenv'
require_relative '../config/DriverManager'
require_relative '../utils/extract_data'
require_relative '../models/WebsiteData'
Dotenv.load

configure do
    set :driver_manager, DriverManager.new
    set :BASE_SIMILARWEB_URL, ENV['BASE_SIMILARWEB_URL']
end

post '/salve_info' do
    content_type :json
    request.body.rewind
    request_body = JSON.parse(request.body.read)
    received_url = request_body['url']
    if (received_url.nil? || received_url.empty?) 
        status(422)
        return {
            error: 'Nenhuma URL fornecida'
        }.to_json
    end

    begin
        encoded_url = CGI.escape(received_url)
        existing_website = WebsiteData.find_by(website_url: encoded_url)
        puts "Existing website: #{existing_website.inspect}"
        if existing_website
            puts 'alolaolaolaolaoaloal-----'
            status(422)
            return { error: 'Site já adicionado à base de dados.' }.to_json
        end
        
        operation_id = SecureRandom.uuid
        driver = settings.driver_manager.get_driver
        BASE_SIMILARWEB_URL = settings.BASE_SIMILARWEB_URL
        driver.get(BASE_SIMILARWEB_URL)
        website_current_url = driver.current_url

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

        website_object = WebsiteData.new(
            operation_id: operation_id,
            website_url: encoded_url,
            company: website_data['company'],
            year_founded: website_data['year_founded'],
            employees: website_data['employees'],
            head_quarters: website_data['hq'],
            annual_revenue: website_data['annual_revenue'],
            industry: website_data['industry'],
            total_visits: website_data['total_visits'],
            bounce: website_data['bounce_rate'],
            pages_per_visit: website_data['pages_per_visit'],
            last_month_change: website_data['last_month_change'],
            average_visit_duration: website_data['avg_visit_duration'],
            global_rank: website_data['global_rank'],
            country_rank: website_data['country_rank'],
            category_rank: website_data['category_rank']
        )

        begin
            website_object.save!
        rescue Mongo::Error => e
            status(500)
            return { error: "Erro ao salvar os dados: #{e.message}" }.to_json
        end
        
        status(201)
        return { message: 'Dados salvos.', data: website_data }.to_json

    rescue => e
        return { error: "Erro ao processar: #{e.message}" }.to_json
    ensure
        settings.driver_manager.quit_driver
    end
end

post '/get_info' do
    content_type :json
    request.body.rewind
    requestBody = JSON.parse(request.body.read)
    received_url = requestBody['url']

    if received_url.nil? || received_url.empty?
        status(422)
        return { error: 'Nenhuma URL fornecida.' }.to_json
    end

    begin
        website_data = WebsiteData.find_by(website_url: received_url)
        unless website_data
            status(404)
            return { error: 'Informações não encontradas.' }.to_json
        end
    end

    status(200)
    return { message: 'Informações encontradas', data: website_data }.to_json

end
