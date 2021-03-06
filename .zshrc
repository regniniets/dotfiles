source $HOME/.zsh-scripts/.zshrc

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=247'
ZSH_AUTOSUGGEST_USE_ASYNC=1

TIMEFMT='%J   %U  user %S system %P cpu %*E total'$'\n'\
'avg shared (code):         %X KB'$'\n'\
'avg unshared (data/stack): %D KB'$'\n'\
'total (sum):               %K KB'$'\n'\
'max memory:                %M MB'$'\n'\
'page faults from disk:     %F'$'\n'\
'other page faults:         %R'

if hash vim; then
    EDITOR=${EDITOR:-vim}
else
    EDITOR=${EDITOR:-vi}
fi
export PAGER=${PAGER:-less}


#install (if necessary) and load zplug
if [[ -z "$ZPLUG_HOME" ]]; then
  ZPLUG_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zplug"
fi
if [[ -z "$ZPLUG_CACHE_DIR" ]]; then
  ZPLUG_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zplug"
fi
if [[ ! -d "$ZPLUG_HOME" ]]; then
  git clone https://github.com/zplug/zplug "$ZPLUG_HOME"
  source "$ZPLUG_HOME/init.zsh" && zplug --self-manage update
else
  source "$ZPLUG_HOME/init.zsh"
fi

zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug 'dracula/zsh', as:theme
zplug 'zsh-users/zsh-completions', depth:1
zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-syntax-highlighting', defer:2
zplug 'zsh-users/zsh-history-substring-search', defer:3
if zplug check 'zsh-users/zsh-history-substring-search'; then
  zmodload zsh/terminfo
  bindkey "$terminfo[cuu1]" history-substring-search-up
  bindkey "$terminfo[cud1]" history-substring-search-down
  #if terminfo is not working:
  #bindkey '^[[A' history-substring-search-up
  #bindkey '^[[B' history-substring-search-down
  #bindkey '^[OA' history-substring-search-up
  #bindkey '^[OB' history-substring-search-down
  
  bindkey -M emacs '^P' history-substring-search-up
  bindkey -M emacs '^N' history-substring-search-down
  bindkey -M vicmd 'k' history-substring-search-up
  bindkey -M vicmd 'j' history-substring-search-down
fi

if [ ! -x "$(command -v fzf)" ]; then
    zplug 'junegunn/fzf-bin', as:command, from:gh-r, rename-to:'fzf', use:"*linux*amd64*"
fi
zplug 'junegunn/fzf', use:'shell/*.zsh'
if zplug check 'junegunn/fzf'; then
  FZF_CTRL_T_COMMAND='fd --type f --hidden --exclude .git --exclude .cache'
  FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
  FZF_DEFAULT_OPTS="--height 40% --reverse --border --inline-info --color=dark,bg+:235,hl+:10,pointer:5"
  source $ZPLUG_REPOS/junegunn/fzf/shell/key-bindings.zsh
  source $ZPLUG_REPOS/junegunn/fzf/shell/completion.zsh
fi

zplug 'Tarrasch/zsh-autoenv'
zplug 'rupa/z', use:z.sh
zplug 'zpm-zsh/clipboard'
zplug 'mdarocha/zsh-windows-title'

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load

zmodload zsh/complist # completion menus
zmodload zsh/mathfunc # better mathematical evaluation
zmodload zsh/termcap 2>/dev/null # terminal resources (if available)
zmodload zsh/terminfo 2>/dev/null # terminal resources (if available)

autoload -Uz zargs # like xargs, but works with globs
autoload -Uz zcalc # like bc, but uses Zsh mathematical evaluation
autoload -Uz zmathfunc; zmathfunc # better mathematical evaluation
autoload -Uz zmv # like mv, but uses patterns (`zmv '(*).lis' '$1.txt'`)

if [ -x "$(command -v fdfind)" ]; then
  alias fd="fdfind"
fi
eval "$(dircolors -b)" # ls colors
alias grep='grep --color=auto ' # in color
alias ls='ls --color=auto -F ' # in color & with classifiers
alias la='ls -lah --color=auto '
alias lh='ls -lh --color=auto '
alias ip='ip -c '
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

alias tree='tree -F ' # with classifiers
alias datea="date +%F"
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gs="git status -sb"
alias mi="mvn clean install -T1C"

weather() {
    curl -s "https://wttr.in/${1:-Wien}?m2F&format=v2"
}

if [[ -a ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

# automatically remove duplicates from these arrays
typeset -U path PATH cdpath CDPATH fpath FPATH manpath MANPATH

# vim: et:sw=2
