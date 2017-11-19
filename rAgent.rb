require 'httparty'
require 'pg'
require 'net/ssh'
require 'sys/filesystem'

conn = PG::Connection.new("dbname=climate port=5432 host=192.168.98.129 user=postgres password=psql123" )

def fillDatabase(conn)
  url = 'http://api.openweathermap.org/data/2.5/weather?q=Heredia,cr&appid=a6625d60bbdd040cdb8daebce9f39ce0'
  response = HTTParty.get(url)
  #Ya que los datos no pesan mucho hacemos insert 300 veces por cada request para así lograr inflar la base de datos.
  i = 0
  while i < 300 do
    conn.exec("INSERT INTO weather (data) values ('#{response}')")
    i += 1
  end
end

def getPartitionSpace
  spaceMb_i = `df -m /dev/sda1`.split(/\b/)[24].to_i
  puts spaceMb_i
end

def getDatabaseSize(conn)
  databaseSizeQuery = conn.exec("SELECT pg_size_pretty(pg_database_size('climate'));")
  databaseSize= databaseSizeQuery.getvalue(0, 0)
  #Se pasa este dato a Integer y se le extraen los valores que no sean numericos
  numberSize = Integer(databaseSize.gsub(/[^0-9]/, ''))
  puts numberSize
  numberSize
end

def clearDBSpace
  #Si la base de datos está por encima de la capacidad indicada entonces se ejecuta el COPY
  #Se debe cambiar el nombre de cada copia para así envitar que le caiga encima a la existente
  #conn.exec("COPY weather to '/hdd/rubycopy.csv with csv'")
  #Ejecuta COPY y espera a que termine de generar el CSV
  #LIMPIA LA TABLA PARA NO TENER DATOS Y SEGUIR INSERTANDO
  puts "Es necesario limpiar la base de datos - Iniciando proceso"
end

#Hilo que se encarga de insertar datos en la base de datos.
queryThread = Thread.new do
  while true do
    #Request al API del clima, obteniendo los datos de Heredia.
    fillDatabase(conn)
    #Se obtiene el tamaño de la base de datos que se está utilizando.
    numberSize = getDatabaseSize(conn)
    #Se obtiene el tamaño de la partición actual en la que se encuentra la base de datos
    getPartitionSpace

    #Se revisa si el tamaño actual de la partición es optimo para seguir recibiendo datos
    if numberSize < 3000
      clearDBSpace
    end

    timeElapsed = Time.now
    puts timeElapsed
    sleep 1
  end
end

queryThread.join
