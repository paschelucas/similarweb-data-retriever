require 'nokogiri'
require 'json'
require 'open-uri'


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

    # begin
    #     encodedUrl = CGI.escape(receivedUrl)
    #     html = Nokogiri::HTML(URI.open("https://www.similarweb.com/website/#{encodedUrl}"))

    #     links = html.css('a')
    #     links.each do |link|
    #         puts link.text
    #     end

    # end

    BASE_WIKIPEDIA_URL = "http://en.wikipedia.org"
    LIST_URL = "#{BASE_WIKIPEDIA_URL}/wiki/List_of_Nobel_laureates"
    page = Nokogiri::HTML(open(LIST_URL))
    rows = page.css('div.mw-content-ltr table.wikitable tr')

    
    return rows


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