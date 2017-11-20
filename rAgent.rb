require 'httparty'
require 'pg'
require 'net/ssh'
require 'sys/filesystem'

conn = PG::Connection.new("dbname=climate port=5432 host=192.168.98.129 user=postgres password=psql123" )

def fillDatabase(conn)
  puts "Iniciando inserción de datos"
  logRegistry(conn,"Inserción de datos",DateTime.now)
  url = 'http://api.openweathermap.org/data/2.5/weather?q=Heredia,cr&appid=a6625d60bbdd040cdb8daebce9f39ce0'
  response = HTTParty.get(url)
  i = 0
  while i < 300 do
    conn.exec("INSERT INTO weather (data) values ('#{response}')")
    i += 1
  end
end

def logRegistry(conn, actionTaken, actionDate)
  conn.exec("INSERT INTO log (actionTaken, actionDate) values ('#{actionTaken}','#{actionDate}')")
end

def getPartitionSpace(conn)
  puts "Obteniendo actual del disco"
  logRegistry(conn,"Revisando espacio en disco",DateTime.now)
  spaceMb_i = `df -m /dev/sda1`.split(/\b/)[24].to_i
  puts "El espacio actual del disco es: " + spaceMb_i.to_s
  spaceMb_i
end

def getDatabaseSize(conn)
  puts "Obteniendo espacio actual de la base de datos"
  databaseSizeQuery = conn.exec("SELECT pg_size_pretty(pg_database_size('climate'));")
  databaseSize= databaseSizeQuery.getvalue(0, 0)
  #Se pasa este dato a Integer y se le extraen los valores que no sean numericos
  numberSize = Integer(databaseSize.gsub(/[^0-9]/, ''))
  puts "El espacio actual de la base es: " + numberSize.to_s
  numberSize
end

def createCSVCopy(conn)
  puts "Empezando proceso de copia de tabla"
  logRegistry(conn,"Creando copia de tabla - CSV",DateTime.now)
  conn.exec("COPY weather to '/hdd/rubycopy.csv with csv'")
  puts "Tabla copiada"
  logRegistry(conn,"Copia finalizada - CSV",DateTime.now)
end

def truncateTable(conn)
  puts "Limpiando tabla"
  logRegistry(conn,"Iniciando TRUNCATE de tabla",DateTime.now)
  conn.exec("TRUNCATE TABLE weather")
  logRegistry(conn,"TRUNCATE finalizado",DateTime.now)
end

def clearDBSpace(conn)
  logRegistry(conn,"Iniciando proceso de limpiezad de tabla",DateTime.now)
  createCSVCopy(conn)
  truncateTable(conn)
  puts "Tabla limpiada - reanudando proceso de inserción de datos"
end

  while true do
    fillDatabase(conn)
    #Se obtiene el tamaño de la partición actual en la que se encuentra la base de datos
    numberSize = getPartitionSpace(conn)
    #Se revisa si el tamaño actual de la partición es optimo para seguir recibiendo datos
    if numberSize < 3000
      clearDBSpace(conn)
    end
  end