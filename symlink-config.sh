#! /bin/sh
DOTFILESDIR=`dirname "$(readlink -f "$0")"`
echo $DOTFILESDIR
echo $HOME
basename $0
echo
cd $DOTFILESDIR
for file in $(find . -type f -not -path "./.git/*" -and -not -name "$( basename $0)"); do
	if [[ -f $HOME/$file ]] && [[ ! -L $HOME/$file ]]; then
		echo $file is real file, do nothing.
	elif  [[ $file -ef $HOME/$file ]]; then
		echo $file already linked.
	else
		mkdir -p $(dirname "$HOME/$file")
		ln -s $DOTFILESDIR/$file $HOME/$file
		echo "$file linked."
	fi
done

