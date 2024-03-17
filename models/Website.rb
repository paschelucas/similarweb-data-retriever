class Website
    include Mongoid::Document

    field :receivedUrl, type: String
    validates :url, presence: true
end