require 'nokogiri'
require 'json'
require 'open-uri'
require 'selenium-webdriver'

options = Selenium::WebDriver::Options.firefox
@driver = Selenium::WebDriver.for :firefox, options: options
@baseSimilarwebUrl = 'https://www.similarweb.com'

@driver.get(@baseSimilarwebUrl)
@wait = Selenium::WebDriver::Wait.new(timeout: 5)

@driver.find_element(class: 'app-banner__dismiss-button').click

# @driver.find_elements(tag_name: 'input')[1].clear
# @driver.find_elements(tag_name: 'input')[1].click

@driver.find_elements(tag_name: 'input')[1].send_keys('testando poxaKKKKKKKKK')
# TODO ja encontramos o input. agora vamos enviar o form
post '/salve_info' do
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
    LIST_URL = "#{BASE_SIMILARWEB_URL}/website/#{encodedUrl}"

    puts "================= #{uri}"
    USER_AGENT = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36'
    html = URI.open("http://www.similarweb.com", {'User-Agent' => USER_AGENT})
    doc = Nokogiri::HTML(html)
    
    
    description = doc.css("p").text
    puts description

    rows = doc.css('div.appcompany-info wa-overview__company')

    rows[1..-2].each do |row|
        hrefs = row.css("td a").map{ |a| 
          a['href'] if a['href'].match("/website/")
        }.compact.uniq
      
        hrefs.each do |href|
         puts href
        end
    end

    return rows.to_s


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