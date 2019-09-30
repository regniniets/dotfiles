typeset -U PATH path
path=("$HOME/bin" "$HOME/bin/apache-maven/bin" "$HOME/.cargo/bin" "$path[@]")
export PATH

export EDITOR=nvim
export PAGER=less
export BROWSER=firefox
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'
