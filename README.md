# Proyecto 2 Administración de Base de Datos - rAgent

Repositorio del agente en Ruby encargado de la revisión y prevención de eventos que afecten la base de datos.


## Getting Started

Instrucciones para poder correr una copia de este script.

### Requisitos

Paquetes y servicios necesarios para la ejecución:

```
PostgresSQL
Ruby
rbenv
Git
```

### Instalación Ruby con rbenv (Seguir pasos de link adjunto)

* [Ruby](https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-16-04) - Ruby y rbenv


Clonación del repositorio

```
git clone https://github.com/LeinadDC/rAgent.git
```

Ejectucar el script

```
ruby rAgent.rb
```

## Hecho con

* [Ruby](https://www.ruby-lang.org/es/) - Programming Language
* [rbenv](https://github.com/rbenv/rbenv) - Ruby version manager
* [PostgreSQL](https://www.postgresql.org/?&) - SQL Database

## Estructura

La solución está compuesta por un solo script que se encarga de toda la ejecución del agente.

## Funcionamiento

Existe un método llamado fillDatabase que se encarga de hacer el request al API, sin embargo el JSON que devuelve tiene un peso sumamente pequeño, por razones educativas y para poder llenar la base de datos, cada request se repite 300 veces para así poder llenar la base de datos y probar correctamente el script.

Existe otro método llamado getPartitionSpace que se encarga de devolver el espacio actual en el disco en el cual se ejecuta el script, y otro método similar que devuelve el espacio de la base de datos que se está usando.

Para el manejo del espacio existen otros 2 métodos llamados createCSVCopy y truncateTable que se ejecutan en ese mismo orden. El primero crea una copia actual de la tabla en formato CSV mientras que el segundo limpia la tabla de datos después de que se crea la copia.


## Autor
* **Daniel Castellano** - *Trabajo Inicial* - [LeinadDC](https://github.com/LeinadDC/)
