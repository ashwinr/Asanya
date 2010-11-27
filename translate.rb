$LOAD_PATH << '.'
require 'rubygems'
require 'uri'
require 'json'
require 'net/https'
require 'bson'
require 'mongoid'
require 'enru.rb'

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

def getRussianTranslations(english_words)

  length, max_length = 0, 500
  query_words, russian_words = [], []
  url_base = 'https://www.googleapis.com/language/translate/v2';
  api_key = 'AIzaSyDWWkVJW5UrlndH4kXOQwHabXKKeto9U3g'

  english_words.each { |word| length += word.length }
  avg_word_length = length / english_words.length 
  split_idx = max_length / avg_word_length
  start = 0

  while start < english_words.length
    query_words << english_words[start...(start+split_idx)]
    start += split_idx
  end

  query_words.each do |words|
    query = words.join('&q=')
    uri = URI.parse("#{url_base}?key=#{api_key}&q=#{query}&source=en&target=ru")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Get.new(uri.request_uri)
    resp = http.request(req)
    if resp.class != Net::HTTPOK
      puts resp.inspect
      return []
    end

    json = JSON.parse(resp.body, {symbolize_names: true})
    json[:data][:translations].each { |word| russian_words << word[:translatedText] }
  end
  
  return russian_words
end

en = []
file = File.open('en_words.txt')
file.each do |line|
  en << line.chop
end

ru = getRussianTranslations(en)

en.zip(ru).each do |english, russian|
  translation = EnRu.new(:english => english, :russian => russian)
  translation.save
end
