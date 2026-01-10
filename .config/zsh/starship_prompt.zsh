export STARSHIP_CONFIG=${XDG_CONFIG_HOME}/starship/config.toml

if ! command -v starship &>/dev/null ; then
    os_kernel="$OSTYPE"
    if [[ "${os_kernel}" == darwin* ]] && command -v brew &>/dev/null ; then
        brew install starship
    elif [[ "${os_kernel}" == linux* ]] ; then
        echo 'Install starship?: curl -sS https://starship.rs/install.sh | sh'
        read -q "reply?Proceed? [y/N] "
        echo    # move to next line
        if [[ "$reply" == [yY] ]]; then
            curl -sS https://starship.rs/install.sh | sh
        else
            echo "Aborted"
            return 1
        fi
    fi

    if command -v starship &>/dev/null ; then
        eval "$(starship init zsh)"
    fi
else
    eval "$(starship init zsh)"
fi
