#!/usr/bin/env bash
set -ue
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" # http://stackoverflow.com/questions/59895
if [ "$#" == "0" ]; then
  echo "$0 serverName command"
  echo "sets CATALINA_BASE to $DIR/serverName and then runs command (usually startup.sh or shutdown.sh)"
  exit 1
fi
export CATALINA_BASE=$DIR/$1
shift
# http://stackoverflow.com/questions/3356476/debugging-monit
$@
