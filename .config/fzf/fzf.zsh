if [[ -f /usr/share/fzf/shell/key-bindings.zsh ]]; then
    source /usr/share/fzf/shell/key-bindings.zsh
fi
fzf_version=$(fzf --version | awk '{print $1}')
cellar_path=$(brew --cellar)
if [[ -f "${cellar_path}/fzf/${fzf_version}/shell/key-bindings.zsh" ]]; then
    source "${cellar_path}/fzf/${fzf_version}/shell/key-bindings.zsh"
fi
