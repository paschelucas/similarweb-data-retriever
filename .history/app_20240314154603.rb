require 'sinatra'
require 'mongoid'

Mongoid.load!(File.join(File.dirname(__FILE__), 'config', 'mongoid.yml'))

get '/' do 
    puts "LKLKLKLKLKLK"
end