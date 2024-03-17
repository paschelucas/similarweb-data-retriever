require 'sinatra'
require 'mongoid'
require 'nokogiri'
require 'json'
require 'open-uri'


Mongoid.load!(File.join(File.dirname(__FILE__), 'config', 'mongoid.yml'))

class Post
    include Mongoid::Document

    field :title, type: String
    field :body, type: String

    has_many :comments

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