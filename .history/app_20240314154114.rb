require 'sinatra'
require 'mongoid'

Mongoid.load!(File.join(File.dirname(__FILE__), 'config', 'mongoid.yml'))

get '/' do 
    puts "LKLKLKLKLKLK"
end

post '/posts' do
    post = Post.create!(params[:post])
    post.to_json

end

get '/posts/:post_id' do |post_id|
    post = Post.find(post_id)
    post.attributes.merge(
        comments: post.comments,
    ).to_json
end

post '/posts/:post_id/comments' do |post_id|
    post = Post.find(post_id)
    comment = post.comments.create!(params[:comment])
    {}.to_json
end
