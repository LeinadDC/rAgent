require 'httparty'
require 'pg'
require 'net/ssh'
require 'sys/filesystem'

#Funciona
conn = PG::Connection.new("dbname=climate port=5432 host=192.168.98.129 user=postgres password=psql123" )
url = 'http://api.openweathermap.org/data/2.5/weather?q=Heredia,cr&appid=a6625d60bbdd040cdb8daebce9f39ce0'
response = HTTParty.get(url)

#puts response
#conn.exec("INSERT INTO weather (data) values ('#{response}')")

HOST = '192.168.0.7'
USER = 'User'
PASS = 'Aliss123'

Net::SSH.start(HOST, USER, :password => PASS) do |ssh|

  result = ssh.exec!('cd C:\Program Files (x86)\VMware\VMware Workstation && vmrun list')
 #ssh.exec('cd "Program Files (x86)"')
 #ssh.exec('cd VMware')
 #ssh.exec('cd VMware Workstation')
  #Comando para clonar
  #result = ssh.exec!('vmrun -T ws clone \Users\User\Documents\vms\Template\Template.vmx \Users\User\Documents\vms\Clone2\Clone2.vmx full -cloneName ="FullClone2"')
  #Comando para iniciar VM
  #result = ssh.exec!('vmrun -T ws start \Users\User\Documents\vms\Clone2\Clone2.vmx')
  #Comando para ver VMs corriendo
  #result = ssh.exec!('vmrun list')
  #Comando para obtener IP de otra VM
  #result = ssh.exec!('vmrun getGuestIPAddress \Users\User\Documents\vms\Clone2\Clone2.vmx')
  puts result
end


stat = Sys::Filesystem.stat("/")
mb_available = stat.block_size * stat.blocks_available / 1024 / 1024

puts "Espacio disponible: #{mb_available}"
if mb_available < 3500
  puts "Es necesario levantar otra máquina virtual"
  puts "Iniciando proceso de clonación de máquina virtual"
  #Clonación de máquina virtual
  puts "Encendiendo máquina virtual"
  #Encender máquina virtual
else
  puts "Esta máquina virtual todavía puede seguir recibiendo datos"
end
