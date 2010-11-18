require 'rubygems'
require 'bundler'

Bundler.require

set :public, './public'
set :views, './views'

require './front'
run Sinatra::Application
