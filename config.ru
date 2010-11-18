require 'rubygems'
require 'bundler'

Bundler.require

set :views, './views'

require './front'
run Sinatra::Application
