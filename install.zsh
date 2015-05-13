#!/bin/zsh
#
# Installs dot files
#

setopt EXTENDED_GLOB

install () {
  local DOTS=${HOME}/.dots
  if [ -d ${DOTS} ]; then
    echo "dots is already installed. Delete your ${DOTS} directory and try again."
    exit 1
  fi

  echo "Checking dependencies..."
  check_dep git git
  check_dep vim vim
  check_dep python python
  check_dep pip python-pip
  check_pip_dep powerline-status

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

  echo "Linking Prezto..."
  ln -s ${DOTS}/prezto ${HOME}/.zprezto
  for rcfile in ${HOME}/.zprezto/runcoms/^README.md(.N); do
    rc="${rcfile:t}"
    if [ -e ${HOME}/.${rc} ]; then
      echo "Backing up .${rc} as .${rc}.bak"
      mv ${HOME}/.${rc} ${HOME}/.${rc}.bak
    fi
    ln -s "${DOTS}/prezto/runcoms/${rc}" ${HOME}/.${rc}
  done

  echo "Linking dot files..."
  for file in *.dot(N); do
    rc=".${file%.dot}"
    if [ -e ${HOME}/${rc} ]; then
      echo "Backing up ${rc} as ${rc}.bak"
      mv ${HOME}/${rc} ${HOME}/${rc}.bak
    fi
    ln -s ${DOTS}/${file} ${HOME}/${rc}
  done

  echo "Installing powerline fonts..."
  ./fonts/install.sh

  if hash gnome-terminal &>/dev/null; then
    echo "Installing solarized theme for gnome-terminal..."
    ${DOTS}/solarized/gnome-terminal/install.sh -s dark -p Default
    if hash gconftool-2 &>/dev/null; then
      local TERM_CONF="/apps/gnome-terminal/profiles/Default"
      gconftool-2 --set "${TERM_CONF}/custom_command" --type string "zsh"
      gconftool-2 --set "${TERM_CONF}/default_show_menubar" --type bool false
      gconftool-2 --set "${TERM_CONF}/use_system_font" --type bool false
      gconftool-2 --set "${TERM_CONF}/font" --type string "Liberation Mono for Powerline 11"
    fi
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

# Checks if the pip package $1 is installed. If not, the user will be
# prompted to install it.
check_pip_dep () {
  if [ $# != 1 ]; then
    echo "incorrect use of check_pip_dep function"
    exit 2
  fi
  if [ -n $(pip show $1) ]; then
    echo "pip package $1 is required"
    if read -q "REPLY?Install pip package $1? [y/N] "; then
      echo "\n"
      if sudo pip install $1; then
        return
      fi
      echo "Failed to install pip package $1"
    fi
    echo "Exiting"
    exit 1
  fi
}

install
