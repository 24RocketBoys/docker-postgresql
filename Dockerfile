## Version 0.0.1
## Basado en http://docs.docker.com/examples/postgresql_service/
FROM nanounanue/docker-base
MAINTAINER Adolfo De Unánue Tiscareño "adolfo.deunanue@itam.mx"

ENV REFRESHED_AT 2015-04-20

## Cambiamos a root
USER root

## Instalamos PostgreSQL 9.4
RUN apt-get install -y python-software-properties postgresql-9.4 postgresql-client-9.4 postgresql-contrib-9.4 \
postgresql-9.4-plv8 postgresql-9.4-postgis postgresql-plpython-9.4


## Cambiamos al usuario PostgreSQL
USER postgres

## Creamos un usuario de base de datos itam y una base de datos itam
RUN  /etc/init.d/postgresql start &&\
    psql --command "CREATE USER itam WITH SUPERUSER PASSWORD 'itam';" &&\
    createdb -O itam itam

## Ajustamos la configuración para que las conexiones remotas sean posibles.
RUN echo "host all  all    0.0.0.0/0  md5" >> /etc/postgresql/9.4/main/pg_hba.conf
RUN echo "listen_addresses='*'" >> /etc/postgresql/9.4/main/postgresql.conf

## Abrimos el puerto
EXPOSE 5432

## Agregamos volumes para así poder respaldar la base de datos y la configuración
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

## Levantamos el servidor
CMD ["/usr/lib/postgresql/9.4/bin/postgres", "-D", "/var/lib/postgresql/9.4/main", "-c", "config_file=/etc/postgresql/9.4/main/postgresql.conf"]
