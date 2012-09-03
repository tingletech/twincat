#!/bin/bash 
set -eu
# will nedd to keep this up to date, server.xml template is for tomcat7
tomcatVer=7.0.29
tomcat=apache-tomcat-$tomcatVer
md5=307076fa3827e19fa9b03f3ef7cf1f3f

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # http://stackoverflow.com/questions/59895
cd $DIR
if [ -e apache-tomcat-7.0.29.tar.gz ]; then
  echo "did you run me before? this should only be run once"
  exit 1
fi
checksum() {	# http://stackoverflow.com/questions/1299833/bsd-md5-vs-gnu-md5sum-output-format
        (md5sum <"$1"; test $? = 127 && md5 <"$1") | cut -d' ' -f1
}
which xsltproc wget	# abort now if commands I need are not installed
# select a random mirror from mirrors.txt
# http://www.hilarymason.com/blog/how-to-get-a-random-line-from-a-file-in-bash/
mirror_length=`wc -l<mirrors.txt|tr -d ' '`
mirror=`tail -$((RANDOM/(32767/$mirror_length))) mirrors.txt|head -1|tr -d "\n"`

wget "$mirror/tomcat/tomcat-7/v$tomcatVer/bin/$tomcat.tar.gz"
check=`checksum $tomcat.tar.gz` 	# check the checksum
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
for catbase in "$@"; do
  ./clonecat.sh "$catbase" $(($START_SHUTDOWN + $offset)) $(($START_LISTEN + $offset))
  offset=$(($offset + 1))	# increment port offset for sequential ports
done

# generate monit config file
# perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg' monitrc.template > monitrc
# chmod 700 monitrc
# create monit directory
# mkdir -p $DIR/logs

if [ "$#" == "0" ]; then
  echo "just grabbing the binary b/c no arguments where provided; use ./clonecat.sh to set up a CATALINA_BASE"
else
  echo "looks like it all worked, $@ should all be configured"
fi
