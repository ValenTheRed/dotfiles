declare -A ZINIT
ZINIT[HOME_DIR]="${HOME}/.local/share/zinit"
ZINIT[BIN_DIR]="${ZINIT[HOME_DIR]}/zinit.git"

source "${ZINIT[BIN_DIR]}/zinit.zsh"
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
# zinit light intelfx/pure
zinit light sindresorhus/pure
source $XDG_CONFIG_HOME/zsh/pure.config


source $XDG_CONFIG_HOME/zsh/.zsh_aliases

unsetopt BEEP
export EDITOR='nvim'

# zsh automatically sets editing mode as `vi` if it detects substring `vi`
# in $EDITOR.
bindkey -v '^K' history-beginning-search-backward
bindkey -v '^J' history-beginning-search-forward

HISTFILE="${HOME}/.local/share/zsh/zsh_history"
# Huge history. Doesn't appear to slow things down, so why not?
HISTSIZE=500000
SAVEHIST=100000
HIST_STAMPS="yyyy-mm-dd"
setopt HIST_SAVE_NO_DUPS # do not save duplicated command
setopt HIST_IGNORE_ALL_DUPS # remove older duplicate entries from history
setopt HIST_REDUCE_BLANKS # remove superfluous blanks from history items
setopt INC_APPEND_HISTORY # save history entries as soon as they are entered
setopt EXTENDED_HISTORY # recordd the timestamp of the command

DIRSTACKSIZE=10
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

setopt MENU_COMPLETE
# this one causes selection on the menu to be highlighted
#zstyle ':completion:*' menu select

autoload -U compinit
compinit

# WINDOWS (MSYS2) ONLY
# The default completion system for /usr/bin/start script doesn't
# complete files. Defining new completion style using `zstyle` didn't
# help. Unset fixes that. (All commands after start will also complete
# files by default now.)
unset '_comps[start]'
