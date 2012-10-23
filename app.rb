require 'sinatra'
require 'json'
require './fizzbuzz'

before do
  content_type 'application/json'
end

get %r{^/fizzbuzz/([\d]+),([\d]+)$} do |a, b|
  a, b = a.to_i, b.to_i
  raise RangeError if a > b

  (a..b).map { |i| i.fizzbuzz }.join("\n").concat("\n").to_json
end

not_found do
  ""
end

error do
  ""
end

