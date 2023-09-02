export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:=${HOME}/.config}
export XDG_DATA_HOME=${XDG_DATA_HOME:=${HOME}/.local/share}
export XDG_STATE_HOME=${XDG_STATE_HOME:=${HOME}/.local/state}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:=${HOME}/.cache}

export ZDOTDIR=${ZDOTDIR:=${XDG_CONFIG_HOME}/zsh}
export HISTFILE=${XDG_STATE_HOME}/zsh/zsh_history

export SHELL_SESSION_DIR=${XDG_STATE_HOME}/zsh/zsh_sessions
if [[ -d ${SHELL_SESSION_DIR} ]]; then
    mkdir -m 700 -p ${SHELL_SESSION_DIR}
fi

export EDITOR=nvim

source ${ZDOTDIR}/.zshenv