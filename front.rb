$LOAD_PATH << '.'
#require 'rubygems'
#require 'sinatra'
#require 'mongoid'
#require 'haml'

require './enru.rb'

configure do
  Mongoid.configure do |config|
    name = 'translatedb'
    host = 'flame.mongohq.com'
    port = 27079
    user = 'ashwinraman9'
    password = '.1jbinoche'
    config.master = Mongo::Connection.new(host, port).db(name)
    config.master.authenticate(user, password)
    config.slaves = [ Mongo::Connection.new(host, port, :slave_ok => true).db(name) ]
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
