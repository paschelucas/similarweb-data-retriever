require 'sinatra'
require 'mongoid'

require_relative 'routes/api'


Mongoid.load!(File.join(File.dirname(__FILE__), 'config', 'mongoid.yml'))


