#! /bin/sh
DOTFILESDIR=`dirname "$(readlink -f "$0")"`
echo $DOTFILESDIR
echo $HOME
basename $0
echo
find . -type f -not -path "./.git/*" -and -not -name "$( basename $0)"

