if [[ "$(uname -s)" == Linux* ]]; then
    alias logoff="pkill -KILL -u ${USER}"
    alias sudo="sudo "
fi
alias es="eza --icons --group-directories-first"
alias ea="eza --icons -a --group-directories-first"
alias el="eza --icons -la --group-directories-first"
alias la="ls -A"
alias ll="ls -lFh"
alias lsa="ls -AlFh"
alias vi="nvim"

# Pass <C-s> to nvim. By default, it's intercepted to perform an 'XOFF'
stty -ixon

# a nice sensible .zshrc file: https://gist.github.com/scottstanfield/fa1085c225069160225d18b1dc16ee1c

# pressing `<S-v>` in normal mode (called command mode in zsh (`man zshzle(1)`))
# will open $EDITOR for editing there (like the feature bash).
# Chose `<S-v>` since `v` is bound to visual mode.
autoload -Uz edit-command-line && zle -N edit-command-line
bindkey -M vicmd V edit-command-line

autoload -Uz compinit && compinit
# smart case matching. `cd d<TAB>` will match `Doc` and `doc`.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Ref for KEYTIMEOUT:
# - https://zsh.sourceforge.io/Doc/Release/Parameters.html#Parameters-Used-By-The-Shell-1
# - https://www.johnhawthorn.com/2012/09/vi-escape-delays/
# 1 = 10ms, default is 0.4s
KEYTIMEOUT=1

# Change cursor shape in vi mode.
# Ref: https://unix.stackexchange.com/a/765611
zle-keymap-select () {
    if [[ $KEYMAP == vicmd ]]; then
        # Command mode: block cursor
        echo -ne "\e[2 q"
    else
        # Insert mode: blinking I-beam cursor
        echo -ne "\e[5 q"
    fi
}
precmd_functions+=(zle-keymap-select)
zle -N zle-keymap-select

source "${ZDOTDIR}/prompt.zsh"

# ZSH automatically sets editing mode as `vi` if it detects substring `vi`
# in $EDITOR. So, no need for `set -o vi` or whatever the ZSH equivalent is.
bindkey -v '^K' history-beginning-search-backward
bindkey -v '^J' history-beginning-search-forward
bindkey -v "^H" backward-delete-char
bindkey -v "^?" backward-delete-char
bindkey "^[[Z" reverse-menu-complete # <S-Tab> to go backwards in tab completion

# History settings
# Setting HISTFILE again because /etc/zshrc sets it, which is sourced after
# ~/.zshenv (and ${ZDOTDIR}/zsh/.zprofile both).
HISTFILE=${XDG_STATE_HOME}/zsh/zsh_history
# ${XDG_STATE_HOME}/zsh folder will always exists since we'll create the
# directory in .zshenv
if [[ ! -f ${HISTFILE} ]]; then
    touch ${HISTFILE}
fi
HISTSIZE=4000000000 # 4294967296 = 2^32
SAVEHIST=$HISTSIZE
HIST_STAMPS="yyyy-mm-dd"
setopt append_history           # allow multiple sessions to append to one history
setopt extended_history         # Record the timestamps along with the commands
setopt hist_save_no_dups        # do not save duplicated command
setopt hist_expire_dups_first   # expire duplicates first when trimming history
setopt hist_find_no_dups        # When searching history, don't repeat
setopt hist_ignore_dups         # ignore duplicate entries of previous events
setopt hist_ignore_all_dups     # ignore duplicate entries even if they aren't previous events
setopt hist_ignore_space        # prefix command with a space to skip it's recording
setopt hist_reduce_blanks       # Remove extra blanks from each command added to history
setopt hist_verify              # Don't execute immediately upon history expansion
setopt inc_append_history       # Write to history file immediately, not when shell quits
setopt share_history            # Share history among all sessions

# Misc
setopt interactive_comments     # allow # comments in shell; good for copy/paste
unsetopt correct_all            # disable ZSH autocorrect

setopt MENU_COMPLETE            # this one causes selection on the menu to be highlighted

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh

# WINDOWS (MSYS2) ONLY
# The default completion system for /usr/bin/start script doesn't
# complete files. Defining new completion style using `zstyle` didn't
# help. Unset fixes that. (All commands after start will also complete
# files by default now.)
# unset '_comps[start]'
