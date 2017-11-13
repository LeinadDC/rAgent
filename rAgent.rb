require 'httparty'
require 'pg'

conn = PG::Connection.new("dbname=climate port=5432 host=192.168.98.129 user=postgres password=kelly123" )
url = 'http://api.openweathermap.org/data/2.5/weather?q=Heredia,cr&appid=a6625d60bbdd040cdb8daebce9f39ce0'
response = HTTParty.get(url)

puts response
conn.exec("INSERT INTO weather (data) values ('#{response}')")
