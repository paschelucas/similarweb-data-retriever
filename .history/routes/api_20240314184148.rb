require 'nokogiri'
require 'json'
require 'open-uri'


get '/salve_info' do
    request.body.rewind
    requestBody = JSON.parse(request.body.read)

    if (!requestBody['name']) 
        puts 'ERREIIIIIIII'

    else
        puts 'duvida nao chef'
        puts requestBody['name'], request.body.read
    end
    # webpage = Nokogiri::HTML(URI.open("https://www.similarweb.com/website/#{URI.escape(url)}"))


    # puts webpage


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