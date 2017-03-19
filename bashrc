#!/bin/bash
# .bashrc

# Source global definitions
[ -f /etc/bashrc ] && source /etc/bashrc

if command -v gcc &> /dev/null; then
  export GNUCC_VER="$(gcc -v &> >(grep -oP 'gcc version \K([0-9]+.[0-9]+.[0-9]+)'))"
fi

case "$(uname -s)" in
  CYGWIN*|MINGW32*|MSYS*)
    # let windows set the JAVA_HOME and M2_REPO environment variables
    # Cygwin doesn't do evaluate dircolors :(
    [ -f "${HOME}/.dircolors" ] && eval "$(dircolors -b ${HOME}/.dircolors)"
    alias ls='ls --color=auto'
    ;;
  *)
    if command -v mvn &> /dev/null && [ -d "${HOME}/.m2/repository" ]; then
      export M2_REPO=${HOME}/.m2/repository
    fi
    if command -v javac &> /dev/null; then
      export JAVA_HOME=$(readlink -f $(which javac) | sed "s:/bin/javac::")
    fi
    ;;
esac

if [ -n "${PS1}" ]; then
  append_to_path() {
    for p in ${@}; do
      case ":${PATH}:" in
        *:"${p}":*) ;;
        *) PATH=${PATH}:${p} ;;
      esac
    done
    export PATH
  }
  remove_from_path() {
    for p in ${@}; do
      PATH=$(echo -n ${PATH} | sed "s;:\?${p};;")
    done
    export PATH
  }
  jhdevsys() {
    export TBRICKS_SYSTEM=jh_dev_sys
    export SYSTEM=jh_dev_sys
    remove_from_path "${HOME}/src/tb/toolchain/x86_64-unknown-linux/bin" \
                     "${HOME}/src/tb/build.x86_64-unknown-linux/bin"
    append_to_path "${HOME}/src/tbdev/toolchain/x86_64-unknown-linux/bin" \
                   "${HOME}/src/tbdev/build.x86_64-unknown-linux/bin"
  }
  jhsys() {
    export TBRICKS_SYSTEM=jh_sys
    export SYSTEM=jh_sys
    remove_from_path "${HOME}/src/tbdev/toolchain/x86_64-unknown-linux/bin" \
                     "${HOME}/src/tbdev/build.x86_64-unknown-linux/bin"
    append_to_path "${HOME}/src/tb/toolchain/x86_64-unknown-linux/bin" \
                   "${HOME}/src/tb/build.x86_64-unknown-linux/bin"
  }
  unset -f append_to_path
  unset -f remove_from_path
  jhdevsys
  export TBRICKS_ADMIN_CENTER=jh_admin_sys
  export TBRICKS_USER=justinh
  export TBRICKS_TBLOG_SNAPSHOT_SIZE=60000
  export TBRICKS_ETC=/etc/tbricks
  export PAGER=/usr/bin/less
  export SYSTEMD_PAGER=/usr/bin/less
  if [ -n "${DISPLAY}" ] && command -v vimx &> /dev/null; then
    export EDITOR=/usr/bin/vimx
  else
    export EDITOR=/usr/bin/vim
  fi
  export SVN_MERGE='vim -d'
  export PROMPT_COMMAND='last=$?;history -a;printf "\e]0;${HOSTNAME} $(date +%H:%M:%S) ${PWD}:${last}\007"'
  export PS1='[\u@\h:\w] '
  export FIGNORE='.svn:.git:.pyc'
  export HISTFILESIZE=10000
  export HISTSIZE=10000
  # Source completeion scripts
  [ -f "${HOME}/.bash_completion.maven" ] && source "${HOME}/.bash_completion.maven"
  [ -f /opt/tbricks/admin/etc/bash/.tbricks_completion.bash ] && source /opt/tbricks/admin/etc/bash/.tbricks_completion.bash
  # Source aliases
  [ -f "${HOME}/.bash_aliases" ] && source "${HOME}/.bash_aliases"
  # append to the history file, don't overwrite it
  shopt -s histappend
  # Combine multiline commands into one in history
  shopt -s cmdhist
  # enable XON/XOFF flow control
  stty -ixon
fi

# added by travis gem
[ -f "${HOME}/.travis/travis.sh" ] && source "${HOME}/.travis/travis.sh"

