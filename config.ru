require 'rubygems'
require 'bundler'

Bundler.require

set :views, File.dirname(__FILE__) + '/views'

require './front'
run Sinatra::Application
