HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

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
zplug 'zsh-users/zsh-autosuggestions'
zplug 'zsh-users/zsh-syntax-highlighting', defer:2
zplug 'zsh-users/zsh-history-substring-search', defer:3
if zplug check zsh-users/zsh-history-substring-search; then
  zmodload zsh/terminfo
  bindkey "$terminfo[cuu1]" history-substring-search-up
  bindkey "$terminfo[cud1]" history-substring-search-down
  bindkey -M emacs '^P' history-substring-search-up
  bindkey -M emacs '^N' history-substring-search-down
  bindkey -M vicmd 'k' history-substring-search-up
  bindkey -M vicmd 'j' history-substring-search-down
fi
zplug 'Tarrasch/zsh-autoenv'
zplug 'rupa/z', use:z.sh
zplug 'zsh-users/zsh-completions', depth:1
zplug "junegunn/fzf-bin",\
    as:command,\
    from:gh-r,\
    rename-to:"fzf",\
    hook-load:"""
        source $ZPLUG_REPOS/junegunn/fzf/shell/key-bindings.zsh
        source $ZPLUG_REPOS/junegunn/fzf/shell/completion.zsh
    """
zplug "junegunn/fzf",\
    as:command,\
    use:bin/fzf-tmux,\
    on:"junegunn/fzf-bin"
if zplug check "junegunn/fzf-bin"; then
    export FZF_DEFAULT_COMMAND='fd --hidden --type file --no-ignore --exclude "/.git/"'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_DEFAULT_OPTS="--height 40% --reverse --border --inline-info --color=dark,bg+:235,hl+:10,pointer:5"
fi

#zplug 'woefe/wbase.zsh'
#zplug "softmoth/zsh-vim-mode"
#zplug "mdarocha/zsh-windows-title"
#zplug "zpm-zsh/clipboard"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load

if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  zle-line-init() { echoti smkx }; zle -N zle-line-init
  zle-line-finish() { echoti rmkx }; zle -N zle-line-finish
fi

setopt append_history # Don't overwrite, append!
setopt auto_pushd # cd foo; cd bar; popd --> in foo again
setopt complete_in_word # more intuitive completions
setopt extended_glob # better globs
setopt extended_history # better history
setopt hist_expire_dups_first # don't fill your history as quickly with junk
setopt hist_ignore_all_dups # Delete old recorded entry if new entry is a duplicate.
setopt hist_ignore_space # ` command` doesn't save to history
setopt hist_reduce_blanks # Remove superfluous blanks before recording entry.
setopt hist_subst_pattern # better globs / parameter expansion
setopt interactive_comments # so pasting live to test works
setopt ksh_glob # better globs
setopt long_list_jobs # easier to read job stuff
setopt no_beep # BEEP
setopt no_rm_star_silent # confirm on `rm *` (default, but let's be safe)
setopt null_glob # sane globbing
setopt pipe_fail # fail when the first command in a pipeline fails
setopt prompt_cr prompt_sp # don't clobber output without trailing newlines
setopt share_history # share history between multiple shells

zmodload zsh/complist # completion menus
zmodload zsh/mathfunc # better mathematical evaluation
zmodload zsh/termcap 2>/dev/null # terminal resources (if available)
zmodload zsh/terminfo 2>/dev/null # terminal resources (if available)
autoload -Uz zargs # like xargs, but works with globs
autoload -Uz zcalc # like bc, but uses Zsh mathematical evaluation
autoload -Uz zmathfunc; zmathfunc # better mathematical evaluation
autoload -Uz zmv # like mv, but uses patterns (`zmv '(*).lis' '$1.txt'`)

zstyle ':completion:*' menu yes select # complete with a nicer menu

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=247'
# more descriptive time
TIMEFMT='%J   %U  user %S system %P cpu %*E total'$'\n'\
'avg shared (code):         %X KB'$'\n'\
'avg unshared (data/stack): %D KB'$'\n'\
'total (sum):               %K KB'$'\n'\
'max memory:                %M MB'$'\n'\
'page faults from disk:     %F'$'\n'\
'other page faults:         %R'
FZF_CTRL_T_COMMAND='fd --type f --hidden --exclude .git --exclude .cache'
FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'

eval "$(dircolors -b)" # ls colors
alias grep='grep --color=auto ' # in color
alias ls='ls --color=auto -F ' # in color & with classifiers
alias la='ls -lah --color=auto '
alias lh='ls -lh --color=auto '
alias vim="nvim"
alias mi="mvn clean install -T1C"
alias tree='tree -F ' # with classifiers

# vim: et:sw=2
