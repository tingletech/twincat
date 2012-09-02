#!/bin/bash 
set -eu
which xsltproc md5sum wget
export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # http://stackoverflow.com/questions/59895

if [ -e apache-tomcat-7.0.29.tar.gz ]; then
  echo "did you run me before? this should only be run once"
  exit 1
fi

wget "http://mirrors.sonic.net/apache/tomcat/tomcat-7/v7.0.29/bin/apache-tomcat-7.0.29.tar.gz"
tomcat=apache-tomcat-7.0.29
md5=307076fa3827e19fa9b03f3ef7cf1f3f
check=`md5sum apache-tomcat-7.0.29.tar.gz | awk '{ print $1 }'` 
# http://tldp.org/LDP/abs/html/comparison-ops.html
# [[ $a == z* ]]   # True if $a starts with an "z" (pattern matching).
if ! [[ "$check" == $md5* ]]; then
  echo "files don't match"
  exit 1
fi
tar zxf $tomcat.tar.gz
ln -s $tomcat tomcat

# leave some notes about how this is set up
wget https://eac-graph-load.googlecode.com/hg/servers/CATALINA_BASE

# create tomcat config for each server
: ${START_LISTEN:="8080"}
: ${START_SHUTDOWN:="12005"}

offset=0
for catbase in appFront appBack; do
  mkdir -p $catbase/webapps
  mkdir -p $catbase/temp
  mkdir -p $catbase/work
  mkdir -p $catbase/logs
  mkdir -p $catbase/bin
  cp -rp $tomcat/conf $catbase/conf
  touch $catbase/bin/setenv.sh
  cp -p $tomcat/bin/tomcat-juli.jar $catbase/bin
  # customize server.xml
  xsltproc                                                                     \
    -o $DIR/$catbase/conf/server.xml                                           \
    --stringparam shutdown_string shutdown-this                                \
    --stringparam shutdown_port $(($START_SHUTDOWN + $offset))                 \
    --stringparam listen_port $(($START_LISTEN + $offset))                     \
    http://eac-graph-load.googlecode.com/hg/servers/xslt/generate_config.xslt \
    http://eac-graph-load.googlecode.com/hg/servers/xslt/server.xml
  offset=$(expr $offset + 1)
done

# generate monit config file
# perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg' monitrc.template > monitrc
# chmod 700 monitrc

# create monit directory
# mkdir -p $DIR/logs

