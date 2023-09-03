setopt PROMPT_SUBST

if ! [[ -d "${ZDOTDIR}/git-prompt.zsh" ]]; then
   git clone --depth=1 'https://github.com/woefe/git-prompt.zsh' "${ZDOTDIR}/git-prompt.zsh"
fi

ZSH_THEME_GIT_PROMPT_PREFIX="〈"
ZSH_THEME_GIT_PROMPT_SUFFIX="〉\n"
ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
ZSH_THEME_GIT_PROMPT_DETACHED="%B%F{cyan}:"
ZSH_THEME_GIT_PROMPT_BRANCH="%B%F{magenta}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SYMBOL="%B%F{yellow}󱞹 "
ZSH_THEME_GIT_PROMPT_UPSTREAM_NO_TRACKING="%B%F{red}✗"
ZSH_THEME_GIT_PROMPT_UPSTREAM_PREFIX="%F{red}(%F{yellow}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SUFFIX="%F{red})"
ZSH_THEME_GIT_PROMPT_BEHIND=" ↓"
ZSH_THEME_GIT_PROMPT_AHEAD=" ↑"
ZSH_THEME_GIT_PROMPT_UNMERGED=" %F{red}-"
ZSH_THEME_GIT_PROMPT_STAGED=" %F{green}+"
ZSH_THEME_GIT_PROMPT_UNSTAGED=" %F{red}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" …"
ZSH_THEME_GIT_PROMPT_STASHED="%F{blue}"
ZSH_THEME_GIT_PROMPT_CLEAN="%B%F{#ff8c00}✓"

source "${ZDOTDIR}/git-prompt.zsh/git-prompt.zsh"

precmd() {
   # This is necessary if you want __last_exit_code() to execute after other
   # prompt functions like __username_and_host(). Otherwise the function
   # doesn't work.
   __exit_code_before_prompt_update=$?
}

function __username_and_host() {
   local user_host=""
   if [[ "${USER}" != 'insert-user-here' ]]; then
       user_host='%n'
   fi
   if [[ "${HOST}" != 'insert-host-here' ]]; then
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
       echo '%F{red}%B%?%b '
   fi
}

#       
# single quotes are important here!
PROMPT='$(__username_and_host)%F{#d8bfd8} %~ %f$(gitprompt)$(__last_exit_code)%F{yellow}%f '
