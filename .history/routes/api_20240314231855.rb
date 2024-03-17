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


    encodedUrl = CGI.escape(receivedUrl)
    html = Nokogiri::HTML(URI.open("http://www.threescompany.com/"))
    links = 
    # webpage = Nokogiri::HTML(URI.open("https://www.similarweb.com/website/#{encodedUrl}"))


    puts encodedUrl
    puts webpage
    return webpage


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