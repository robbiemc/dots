#!/bin/zsh
#
# Installs dot files
#

setopt EXTENDED_GLOB

DOTS=${DOTS:-${HOME}/.dots}
install () {
  if [[ -d ${DOTS} ]]; then
    print "dots is already installed. Delete your ${DOTS} directory and try again."
    exit 1
  fi

  print "Installing tools..."
  check_bin git git
  check_bin vim vim-nox vim
  check_bin curl curl
  check_bin tmux tmux
  check_bin xclip xclip
  check_bin tree tree
  check_bin rg ripgrep
  check_bin fzf fzf
  check_bin fd fd rust-fd-find
  check_bin python2 python2
  check_bin python3 python3

  print "Cloning dots..."
  if ! git clone git://github.com/robbiemc/dots.git ${DOTS}; then
    print "Error cloning the dots repository"
    exit 1
  fi

  print "Initializing submodules..."
  cd ${DOTS}
  if ! git submodule update --init --recursive; then
    print "Failed to setup dots submodules"
    exit 1
  fi

  source link.zsh

  print "Installing powerline fonts..."
  ./fonts/install.sh

  if hash gnome-terminal &>/dev/null; then
    print "Installing solarized theme for gnome-terminal..."
    printf "1\nYES" | ${DOTS}/solarized/gnome-terminal/install.sh -s dark --install-dircolors
  fi

  print "Creating temp directories..."
  mkdir -p ${HOME}/.local/share/vim/swap
  mkdir -p ${HOME}/.local/share/vim/undo
  mkdir -p ${HOME}/.local/share/vim/backup
  mkdir -p ${HOME}/.cache/zsh/completion

  print "Creating ~/.custom directory"
  mkdir -p ${HOME}/.custom
  mkdir -p ${HOME}/.custom/vim
  ln -s ${HOME}/.custom/vim ${DOTS}/vim.dot/bundle/custom

  if [[ ! -e ${HOME}/.custom/gitconfig ]]; then
    print "No custom gitconfig exists containing name and email."
    if read -q "REPLY?Would you like to create one? [y/N] "; then
      print # newline
      read "name?name: "
      read "email?email: "
      echo "[user]" > ${HOME}/.custom/gitconfig
      echo "  name = $name" >> ${HOME}/.custom/gitconfig
      echo "  email = $email" >> ${HOME}/.custom/gitconfig
    fi
  fi

  if hash apt-get &>/dev/null; then
    print "Installing YouCompleteMe"
    sudo apt-get --assume-yes install build-essential cmake python3-dev
    pushd vim.dot/bundle/ycm
    python3 install.py --clang-completer
    popd
  else
    print "Please manually install YouCompleteMe, in '${DOTS}/vim.dot/bundle/ycm'"
  fi

  print "Dot files installed! Restart your shell."
}

# Checks if command $1 is defined. If not, and apt is available, it checks
# if any of the remaining arguments are availble in apt's repositories,
# prompts the user to install it, and installs it. Returns 0 if $1 is
# available.
check_bin () {
  if [[ $# -lt 2 ]]; then
    print "Incorrect use of check_bin."
    exit 2
  fi
  if hash $1 &>/dev/null; then
    print "'$1' found"
    return 0
  fi
  print "'$1' not found"
  if ! hash apt-get &>/dev/null || ! hash apt-cache &>/dev/null; then
    print "'apt' is required to install dependencies"
    exit 1
  fi
  for package in "${@:2}"; do
    if ! apt-cache show $package &>/dev/null; then
      print "  Package '$package' not found."
    else
      if read -q "REPLY?  Package '$package' found. Install? [y/N] "; then
        print
        if sudo apt-get --assume-yes install $2; then
          return 0
        fi
        print "Failed to install '$package'"
        exit 1
      fi
      print
    fi
  done
  print "  WARNING: '$1' not installed!"
  return 1
}

install
