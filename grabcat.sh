#!/bin/bash 
#
# grabs apache tomcat from a mirror and unpacks it
# sets up CATALINA_BASE directories for any command line arguments
#
set -eu

# will nedd to keep this up to date, server.xml template is for tomcat7
tomcatVer=7.0.41
tomcat=apache-tomcat-$tomcatVer
md5=cca4176d9901ca1300a56390c36fd6f0

# ports for the main tomcat and the shutdown are assiged sequentially starting at
: ${START_LISTEN:="8080"}
: ${START_SHUTDOWN:="12005"}

export DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # http://stackoverflow.com/questions/59895
cd $DIR
if [ -e $tomcat.tar.gz ]; then
  echo "did you run me before? this should only be run once"
  exit 1
fi
checksum() {	# http://stackoverflow.com/questions/1299833/bsd-md5-vs-gnu-md5sum-output-format
        (md5sum <"$1"; test $? = 127 && md5 <"$1") | cut -d' ' -f1
}
which wget	# abort now if commands I need are not installed
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

offset=0
for catbase in "$@"; do
  ./clonecat.sh "$catbase" $(($START_LISTEN + $offset)) $(($START_SHUTDOWN + $offset))
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
