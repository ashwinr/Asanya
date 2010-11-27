require './enru.rb'

configure do
  Mongoid.configure do |config|
    creds = IO.readlines('./creds');
    creds.map! { |line| line.chomp() }
    name = 'translatedb'
    host, port = 'flame.mongohq.com', 27079
    user, password = creds[0], creds[1]
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
