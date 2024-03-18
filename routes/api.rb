require 'selenium-webdriver'
require 'securerandom'
require_relative '../config/DriverManager'
require_relative '../utils/extract_data'
require_relative '../models/WebsiteData'

configure do
    set :driver_manager, DriverManager.new
    set :BASE_SIMILARWEB_URL, 'https://www.similarweb.com'
end

post '/salve_info' do
    operation_id = SecureRandom.uuid
    result = nil

    Thread.new do
        begin
            request.body.rewind
            requestBody = JSON.parse(request.body.read)
            receivedUrl = requestBody['url']
            if (receivedUrl.nil? || receivedUrl.empty?) 
                status(422)
                return {
                    error: 'Nenhuma URL fornecida'
                }.to_json
            end
            
            encodedUrl = CGI.escape(receivedUrl)
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
            }

            driver = settings.driver_manager.get_driver
            BASE_SIMILARWEB_URL = settings.BASE_SIMILARWEB_URL
            driver.get(BASE_SIMILARWEB_URL)
            
            close_popup_button = driver.find_element(class: 'app-banner__dismiss-button')
            close_popup_button.click if close_popup_button
            driver.find_elements(tag_name: 'input')[1].send_keys(encodedUrl)

            buttons = driver.find_elements(tag_name: 'button')
            search_button = buttons.filter { |button| button.text == 'Search' }[0]
            search_button.click

            info_boxes = driver.find_elements(class: 'engagement-list__item')
            extract_data(info_boxes, website_data)
            info_card_rows = driver.find_elements(class: 'app-company-info__row')
            extract_data(info_card_rows, website_data)


            website_object = WebsiteData.new(
                operation_id: operation_id,
                company: website_data['Company'],
                year_founded: website_data['Year Founded'],
                employees: website_data['Employees'],
                head_quarters: website_data['HQ'],
                annual_revenue: website_data['Annual Revenue'],
                industry: website_data['Industry'],
                total_visits: website_data['Total Visits'],
                bounce: website_data['Bounce Rate'],
                pages_per_visit: website_data['Pages per Visit'],
                last_month_change: website_data['Last Month Change'],
                average_visit_duration: website_data['Avg Visit Duration']
            )

            unless website_object.valid?
                status(422)
                return { error: "Erro na requisição: #{website_object.errors.full_messages}" }.to_json
            end

            begin
                website_object.save!
            rescue StandardError => e
                status(500)
                return { error: "Erro ao salvar os dados: #{e.message}" }
            end
            
            result = { message: 'Dados salvos!', data: website_data }.to_json

        rescue => e
            result = { error: "Erro ao processar: #{e.message}" }
        ensure
            settings.driver_manager.quit_driver
        end
    end.join

    Thread.pass until result

    result = JSON.parse(result) if result.is_a?(String)
    status(result.key?(:error) ? 500 : 201)

    return result.to_json
end


# get '/posts' do 
#     Post.all.to_json
# end

# post '/posts' do
#     puts params
#     post = Post.create!(params[:post])
#     post.to_json

# end

# get '/posts/:post_id' do |post_id|
#     post = Post.find(post_id)
#     post.attributes.merge(
#         comments: post.comments,
#     ).to_json
# end

# post '/posts/:post_id/comments' do |post_id|
#     post = Post.find(post_id)
#     comment = post.comments.create!(params[:comment])
#     {}.to_json
# end

# after do
#     settings.driver_manager.quit_driver
# end
