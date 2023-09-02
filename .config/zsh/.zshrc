alias es="exa --icons --group-directories-first"
alias ea="exa --icons -a --group-directories-first"
alias el="exa --icons -la --group-directories-first"

alias la="ls -A"
alias ll="ls -lFh"
alias lsa="ls -AlFh"

alias vi="nvim"

# a nice sensible .zshrc file: https://gist.github.com/scottstanfield/fa1085c225069160225d18b1dc16ee1c

# pressing `<S-v>` in normal mode (called command mode in zsh (`man zshzle(1)`))
# will open $EDITOR for editing there (like the feature bash).
# Chose `<S-v>` since `v` is bound to visual mode.
autoload edit-command-line && zle -N edit-command-line
bindkey -M vicmd V edit-command-line

autoload -Uz compinit && compinit
# smart case matching. `cd d<TAB>` will match `Doc` and `doc`.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

setopt PROMPT_SUBST

precmd() {
    # This is necessary if you want __last_exit_code() to execute after other
    # prompt functions like __username_and_host(). Otherwise the function
    # doesn't work.
    __exit_code_before_prompt_update=$?
}

function __username_and_host() {
    local user_host=""
    if [[ "${USER}" != 'insert-your-user-name' ]]; then
        user_host='%n'
    fi
    if [[ "${HOST}" != 'insert-your-host-name' ]]; then
        user_host="${user_host}@%m"
    fi
    if [[ -n "${SSH_CLIENT}" ]]; then
        user_host='%n@%m'
    fi
    if [[ -n "${user_host}" ]]; then
        echo "%F{cyan} ${user_host} "
    fi
}

function __last_exit_code() {
    if (( $__exit_code_before_prompt_update != 0 )); then
        echo '%F{red}%B%?%b'
    fi
}

#       
# single quotes are important here!
PROMPT='$(__username_and_host)%F{green} %~$(__last_exit_code) %F{yellow}%f '

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
HISTSIZE=500000
SAVEHIST=100000
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

# WINDOWS (MSYS2) ONLY
# The default completion system for /usr/bin/start script doesn't
# complete files. Defining new completion style using `zstyle` didn't
# help. Unset fixes that. (All commands after start will also complete
# files by default now.)
# unset '_comps[start]'
