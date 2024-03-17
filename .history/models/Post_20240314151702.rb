class Post
    include Mongoid::Document

    field :title, type: String
    field :body, type: String

    has_many :comments

end

class Comment 
    include Mongoid::Document

    field :name, type: String
    field :message, type: String

    belongs_to :post
end

get '/posts' do 
    Post.all.to_json
end

post '/posts' do
    post = Post.create!(params[:post])
    post.to_json

end

get '/posts/:post_id' do |post_id|
    post = Post.find(post_id)
    post.attributes.merge(
        
    )
end