require 'sinatra'
require 'mongoid'

Mongoid.load!(File.join(File.dirname(__FILE__), ''))