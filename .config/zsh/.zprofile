os_kernel="$(uname -s)"
if [[ "${os_kernel}" == Darwin* ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

java_installed=false
if [[ "${os_kernel}" == Darwin* ]] && "${java_installed}"; then
    export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home
fi

android_installed=true
if "${android_installed}"; then
    export ANDROID_HOME=${HOME}/opt/Android/Sdk
    export PATH=${PATH}:${ANDROID_HOME}/emulator
    export PATH=${PATH}:${ANDROID_HOME}/platform-tools
fi

export PATH=${PATH}:${XDG_BIN_HOME}
if [[ -d /opt/ps/lua_ls ]]; then
    export PATH=${PATH}:/opt/ps/lua_ls/bin
fi
if [[ -d /opt/ps/neovim ]]; then
    export PATH=${PATH}:/opt/ps/neovim/bin
fi
