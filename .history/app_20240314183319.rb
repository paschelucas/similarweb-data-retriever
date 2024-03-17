require 'sinatra'
require 'mongoid'
require 'nokogiri'
require 'json'
require 'open-uri'

require


Mongoid.load!(File.join(File.dirname(__FILE__), 'config', 'mongoid.yml'))


