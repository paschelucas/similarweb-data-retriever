require 'selenium-webdriver'
require 'securerandom'
require 'dotenv'
require_relative '../config/DriverManager'
require_relative '../utils/extract_data'
require_relative '../models/WebsiteData'
require_relative '../utils/scraper/website_scraper'
Dotenv.load

post '/salve_info' do
    content_type :json
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
        if existing_website
            status(422)
            return { error: 'Site já adicionado à base de dados.' }.to_json
        end
        
        website_data = WebsiteScraper.fetch_website_data(encoded_url)
        operation_id = SecureRandom.uuid
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
    request_body = JSON.parse(request.body.read)
    received_url = request_body['url']

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
        status(200)
        return { message: 'Informações encontradas', data: website_data }.to_json
    end
end
