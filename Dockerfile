# imagen de Jenkins con los plugins de Docker más comúnmente utilizados y el CLI de Docker 
# instalado
FROM jenkins/jenkins:latest-jdk17

USER root

# añadir al usuario Jenkins al grupo 999, para que, cuando se monte un socket a este 
# contenedor, el usuario Jenkins pueda acceder al socket, evitando que el usuario del 
# contenedor tenga que ser Root
RUN groupadd --gid 999 docker && \
    usermod -aG docker jenkins

# script para la instalacion de las herramientas cliente de Docker
WORKDIR /root
COPY script_instalacion_docker.sh .
RUN chmod u+x script_instalacion_docker.sh
RUN sh -c ./script_instalacion_docker.sh

WORKDIR /var/jenkins_home
USER jenkins

# instalacion de los plugins de Docker para Jenkins
COPY plugins.txt .
RUN jenkins-plugin-cli --plugin-file `pwd`/plugins.txt && \
    rm plugins.txt
