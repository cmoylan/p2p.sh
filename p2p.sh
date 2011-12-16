#!/bin/bash

# P2P Shell Utility
#
# To best use this file, alias it like so:
# alias p2p=". ./p2p.sh"
#
# The first dot is necessary to make the cd commands work.

P2P_ROOT=$HOME/Programs/Rails/p2p


# Show usage and exit if no arguments were passed
if [ ! -n "$1" ]
then
  show_help
fi


# Help text
show_help() {
  echo "COMMANDS:"
  echo "  b\t - restart apache"
  echo "  t\t - touch tmp/restart.txt in the current working directory"
  echo "  ta\t - touch tmp/restart.txt in core/content under P2P_ROOT"
  echo "  c\t - cd to content directory in P2P_ROOT"
  echo "  cr\t - cd to core direcoty in P2P_ROOT"
  echo "  g\t - relink app using git sources"
  echo "  svn\t - relink app using svn sources"
}

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

# Switch symlinks between svn and git codebases
remove_symlinks() {
  echo " ----- removing old symlinks -----"
  rm $P2P_ROOT/core $P2P_ROOT/content
}

# TODO: refactor into one function with an argument to indicate git or svn
switch_to_git() {
  remove_symlinks

  cd $P2P_ROOT
  echo " ----- relinking core -----"
  ln -s $P2P_ROOT/git/core core
  echo " ----- relinking content -----"
  ln -s $P2P_ROOT/git/content content
  bounce
}

switch_to_svn() {
  remove_symlinks

  cd $P2P_ROOT
  echo " ----- relinking content -----"
  ln -s $P2P_ROOT/trunk/core core
  echo " ----- relinking content -----"
  ln -s $P2P_ROOT/trunk/content content
  bounce
}

# Parse command line args
for arg in "$@"
do
  case "$arg" in
    "b" | "bounce" ) bounce;;
    "t" | "touch" ) touch_either;;
    "ta" ) touch_core; touch_content;;
    "cr" | "core") go_core;;
    "c" | "content") go_content;;
    "g" | "git" ) switch_to_git;;
    "svn" ) switch_to_svn;;
    * )
      echo "ERROR: Invalid argument"
      echo ""
      show_help
    ;;
  esac
done
