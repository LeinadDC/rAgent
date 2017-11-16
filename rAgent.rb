require 'httparty'
require 'pg'
require 'net/ssh'
require 'sys/filesystem'

conn = PG::Connection.new("dbname=climate port=5432 host=192.168.98.129 user=postgres password=psql123" )
#Hilo que se encarga de insertar datos en la base de datos.
postgresThread = Thread.new do
  while true do
    url = 'http://api.openweathermap.org/data/2.5/weather?q=Heredia,cr&appid=a6625d60bbdd040cdb8daebce9f39ce0'
    response = HTTParty.get(url)
    conn.exec("INSERT INTO weather (data) values ('#{response}')")
    timeElapsed = Time.now
    puts timeElapsed
    sleep 6
  end
end

postgresThread.join

stat = Sys::Filesystem.stat("/")
mb_available = stat.block_size * stat.blocks_available / 1024 / 1024

puts "Espacio disponible: #{mb_available}"
#if mb_available < 3500
 # puts "Es necesario levantar otra máquina virtual"
  #puts "Iniciando proceso de clonación de máquina virtual"
  #Clonación de máquina virtual
  #puts "Encendiendo máquina virtual"
  #Encender máquina virtual
#else
 # puts "Esta máquina virtual todavía puede seguir recibiendo datos"
#end
