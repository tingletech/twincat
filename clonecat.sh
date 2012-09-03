#!/bin/bash 
set -eu
# will nedd to keep this up to date, server.xml template is for tomcat7
tomcatVer=7.0.29
tomcat=apache-tomcat-$tomcatVer
md5=307076fa3827e19fa9b03f3ef7cf1f3f

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # http://stackoverflow.com/questions/59895
cd $DIR
if [ "$#" -lt "3" ]; then
  echo "$0 base port shutdown"
  echo "set up a CATALINA_BASE <base> configured to listen on <port> with a shutdown port at <shutdown>"
  exit 1
fi
which xsltproc 	# abort now if commands I need are not installed

clonecat() {  
  catbase="$1"	# CATALINA_BASE directory name, listen port, shutdown port
  mkdir -p "$catbase"/temp
  mkdir -p "$catbase"/work
  mkdir -p "$catbase"/logs
  mkdir -p "$catbase"/bin
  cp -rp tomcat/conf "$catbase"/conf
  touch "$catbase"/bin/setenv.sh
  cp -p tomcat/bin/tomcat-juli.jar "$catbase"/bin
  # customize server.xml
  safebase=`echo "$catbase" | tr " " "_"`   # don't want to mess with supporting spaces in shutdown string paramater
  xsltproc                                                                     \
    -o "$catbase"/conf/server.xml                                              \
    --stringparam shutdown_string twincat-shutdown-$safebase                   \
    --stringparam shutdown_port "$2"                                           \
    --stringparam listen_port "$3"                                             \
    http://eac-graph-load.googlecode.com/hg/servers/xslt/generate_config.xslt  \
    http://eac-graph-load.googlecode.com/hg/servers/xslt/server.xml
  echo "$1 configured"
  echo "'./wrapper.sh $1 ./tomcat/bin/startup.sh' will start the server on $2"
  echo "'./wrapper.sh $1 ./tomcat/bin/shutdown.sh' will stop the server via $3"
}

clonecat "$1" "$2" "$3"
