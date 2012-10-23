require 'sinatra'
require 'json'
require './fizzbuzz'

before do
  content_type :json, charset: 'utf-8'
end

get %r{^/fizzbuzz/([\d]+),([\d]+)$} do |a, b|
  a, b = a.to_i, b.to_i
  raise RangeError if a > b

  stream do |out|
    out << '"'
    (a..b).each do |i|
      out << i.fizzbuzz << "\\n"
    end
    out << '"'
  end
  #(a..b).map { |i| i.fizzbuzz }.join("\n").concat("\n").to_json
end

not_found do
  ""
end

error do
  ""
end

