require 'sinatra'
require 'mongoid'
require 'dotenv'
require_relative 'routes/api'
Dotenv.load


Mongoid.load!(File.join(File.dirname(__FILE__), 'config', 'mongoid.yml.erb'))
