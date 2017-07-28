#! /bin/sh

# copie du rest server
cp rest-server.war $CATALINA_HOME/webapps
# il faut que la conf soit déjà là
cp server.xml $CATALINA_HOME/conf
# démarrage du rest-server
cd $CATALINA_HOME
./catalina.sg run jdpa

# Attache process
# mettre les apec-bin sous git en bin-w

