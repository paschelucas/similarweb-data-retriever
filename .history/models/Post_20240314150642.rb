class Post
    include Mongoid::Document

    field :title, type: String
    field :body, type: String

    has_many :comments

end

class Comment 
    include Mongoid::Document
    
end