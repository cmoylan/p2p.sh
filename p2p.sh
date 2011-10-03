#!/bin/bash

# P2P Shell Utility
#
# To best use this file, alias it like so:
# alias p2p=". ./p2p.sh"
#
# The first dot is necessary to make the cd commands work.

P2P_ROOT=$HOME/Programs/Rails/p2p


# Bounce apache
bounce() {
  echo " ----- restarting apache -----"
  sudo apachectl restart
}

# Switch from git to svn

# Touch tmp/restart
touch_core() {
  echo " ----- bouncing core app -----"
  touch $P2P_ROOT/core/tmp/restart.txt
}

touch_content() {
  echo " ----- bouncing content app -----"
  touch $P2P_ROOT/content/tmp/restart.txt
}

# Determine which directory the user is in, and touch that app
touch_either() {
  # look for tmp, if its there, touch restart.txt
  # TODO: need to make this work from anywhere in a p2p app directory
  if [[ -e "./tmp" ]]
  then
    echo " ----- bouncing app -----"
    `touch tmp/restart.txt`
  else
    echo "- Error: tmp/restart.txt not found"
  fi
}

# Go to core
go_core() {
  cd $P2P_ROOT/core
}

# Go to contet
go_content() {
  cd $P2P_ROOT/content
}

# Parse command line args
for arg in "$@"
  # TODO: no args - show help
do
  case "$arg" in
    "b" | "bounce" ) bounce;;
    "t" | "touch" ) touch_either;;
    "ta" ) touch_core; touch_content;;
    "cr" | "core") go_core;;
    "c" | "content") go_content;;
  esac
done