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
    [ -f ${HOME}/.dircolors ] && eval "$(dircolors -b ${HOME}/.dircolors)"
    alias ls='ls --color=auto'
    ;;
  *)
    if command -v mvn &> /dev/null && [ -d ${HOME}/.m2/repository ]; then
      export M2_REPO=${HOME}/.m2/repository
    fi
    if command -v javac &> /dev/null; then
      export JAVA_HOME=$(readlink -f $(which javac) | sed "s:/bin/javac::")
    fi
    ;;
esac

if [ "$PS1" ]; then
  cdpath() {
    cd "${1}/${2}"
  }

  _cdpath() {
    local cur path len dirs
    cur="${COMP_WORDS[COMP_CWORD]}"
    path="${1}"
    len=$((${#path} + 1))
    for d in "${path}/${cur}"*; do
      if [ -d "${d}" ] && [[ "${d}" != */target* ]]; then
        dirs+="${d:$len}/ "
      fi
    done
    COMPREPLY=( $(compgen -W "${dirs}" "${cur}") )
  }

  export PAGER=/usr/bin/less
  export SYSTEMD_PAGER=/usr/bin/less
  export EDITOR=/usr/bin/vim
  export SVN_MERGE='vim -d'
  export PROMPT_COMMAND='last=$?;history -a;printf "\e]0;${HOSTNAME} $(date +%H:%M:%S) ${PWD}:${last}\007"'
  export PS1='[\u@\h:\w] '
  export FIGNORE='.svn:.git:.pyc'
  export HISTFILESIZE=10000
  export HISTSIZE=10000
  # Source completeion scripts
  [ -f ${HOME}/.bash_completion.maven ] && source ${HOME}/.bash_completion.maven
  # Source aliases
  [ -f ${HOME}/.bash_aliases ] && source ${HOME}/.bash_aliases
  # append to the history file, don't overwrite it
  shopt -s histappend
  # Combine multiline commands into one in history
  shopt -s cmdhist
  # enable XON/XOFF flow control
  stty -ixon
fi


# Source orc bashrc
[ -f ${HOME}/.bashrc.orc ] && source ${HOME}/.bashrc.orc

# Source TBricks bashrc
[ -f ${HOME}/.bashrc.tbricks ] && source ${HOME}/.bashrc.tbricks

