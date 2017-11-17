require 'httparty'
require 'pg'
require 'net/ssh'
require 'sys/filesystem'

conn = PG::Connection.new("dbname=climate port=5432 host=192.168.74.128 user=postgres password=psql123" )
#Hilo que se encarga de insertar datos en la base de datos.

queryThread_stopped = true

queryThread = Thread.new do
  while true do
    Thread.stop if queryThread_stopped
    url = 'http://api.openweathermap.org/data/2.5/weather?q=Heredia,cr&appid=a6625d60bbdd040cdb8daebce9f39ce0'
    response = HTTParty.get(url)
    conn.exec("INSERT INTO weather (data) values ('#{response}')")
    #conn.exec("COPY weather to '/hdd/rubycopy.csv with csv'")
    timeElapsed = Time.now
    puts timeElapsed
    sleep 2
  end
end

revisionThread = Thread.new do
  while true do
    databaseSizeQuery = conn.exec("SELECT pg_size_pretty(pg_database_size('climate'));")
    databaseSize= databaseSizeQuery.getvalue(0,0)
    puts ("El tamaño de la tabla es " + databaseSize)
    queryThread_stopped = false
    queryThread.wakeup
    sleep 2
  end
end

revisionThread.join
queryThread.join


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
