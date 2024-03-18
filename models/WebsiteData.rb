class WebsiteData
    include Mongoid::Document

    field :company, type: String
    field :year_founded, type: Integer
    field :employees, type: Integer
    field :head_quarters, type: String
    field :annual_revenue, type: String
    field :industry, type: String
    field :total_visits, type: String
    field :bounce, type: String
    field :pages_per_visit, type: Float
    field :last_month_change, type: String
    field :average_visit_duration, type: String
end