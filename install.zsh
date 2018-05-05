#!/bin/zsh
#
# Installs dot files
#

setopt EXTENDED_GLOB

${DOTS:=$HOME/.dots}
install () {
  if [ -d ${DOTS} ]; then
    echo "dots is already installed. Delete your ${DOTS} directory and try again."
    exit 1
  fi

  echo "Checking dependencies..."
  check_dep git git
  check_dep vim vim-nox

  echo "Cloning dots..."
  if ! git clone git://github.com/robbiemc/dots.git ${DOTS}; then
    echo "Error cloning the dots repository"
    exit 1
  fi

  echo "Initializing submodules..."
  cd ${DOTS}
  if ! git submodule update --init --recursive; then
    echo "Failed to setup dots submodules"
    exit 1
  fi

  source link.zsh

  echo "Installing powerline fonts..."
  ./fonts/install.sh

  if hash gnome-terminal &>/dev/null; then
    echo "Installing solarized theme for gnome-terminal..."
    ${DOTS}/solarized/gnome-terminal/install.sh -s dark --install-dircolors
  fi

  echo "Creating vim temp directories..."
  mkdir -p ${HOME}/.local/share/vim/swap
  mkdir -p ${HOME}/.local/share/vim/undo
  mkdir -p ${HOME}/.local/share/vim/backup

  echo "Creating ~/.custom directory"
  mkdir -p ${HOME}/.custom
  mkdir -p ${HOME}/.custom/vim
  ln -s ${HOME}/.custom/vim ${DOTS}/vim.dot/bundle/custom

  if [ ! -e ${HOME}/.custom/gitconfig ]; then
    echo "No custom gitconfig exists containing name and email."
    if read -q "REPLY?Would you like to create one? [y/N] "; then
      echo # newline
      read "name?name: "
      read "email?email: "
      echo "[user]" > ${HOME}/.custom/gitconfig
      echo "  name = $name" >> ${HOME}/.custom/gitconfig
      echo "  email = $email" >> ${HOME}/.custom/gitconfig
    fi
  fi

  echo "Dot files installed! Restart your shell."
}


# Checks if command $1 is defined. If not, and apt is available, and it has
# package $2, the user will be prompted to install the package. If they
# choose not to, or one or more of the aforementioned conditions are not
# met, the script will exit.
check_dep () {
  if [ $# != 2 ]; then
    echo "incorrect use of check_dep function"
    exit 2
  fi
  if ! hash $1 &>/dev/null; then
    echo "package $1 is required"
    # Check if we can install the dependency
    if hash apt-get &>/dev/null && hash apt-cache &>/dev/null &&
        apt-cache show $2 &>/dev/null; then
      if read -q "REPLY?Install $2? [y/N] "; then
        echo "\n"
        if sudo apt-get --assume-yes install $2; then
          return
        fi
        echo "Failed to install package $1"
      fi
    fi
    echo "Exiting"
    exit 1
  fi
}

install
