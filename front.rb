$LOAD_PATH << '.'
require 'rubygems'
require 'sinatra'
require 'mongoid'
require 'haml'
require 'sass'
require 'enru.rb'

configure do
  Mongoid.configure do |config|
    name = 'translatedb'
    host = 'localhost'
    config.master = Mongo::Connection.new.db(name)
    config.slaves = [ Mongo::Connection.new(host, 27017, :slave_ok => true).db(name) ]
    config.persist_in_safe_mode = false
  end
end

get '/' do
  random = rand(EnRu.count())
  tr = EnRu.skip(random).limit(1).first
  @english = tr.english
  @russian = tr.russian
  haml :frontpage  
end

get '/next' do
  random = rand(EnRu.count())
  tr = EnRu.skip(random).limit(1).first
  "<translations><english>#{tr.english}</english><russian>#{tr.russian}</russian></translations>"
end

get '/styles.css' do
  scss :styles
end
