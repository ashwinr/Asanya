require 'rubygems'
require 'mongoid'

class EnRu
  include Mongoid::Document
  field :english
  field :russian
end
