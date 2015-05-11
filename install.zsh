#!/bin/zsh
#
# Installs dot files
#

setopt EXTENDED_GLOB

install () {
  DOTS=~/.dots
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
  ln -s ${DOTS}/prezto ~/.zprezto
  for rcfile in ~/.zprezto/runcoms/^README.md(.N); do
    rc=".${rcfile:t}"
    if [ -e ~/${rc} ]; then
      echo "Backing up ${rc} as ${rc}.bak"
      mv ~/${rc} ~/${rc}.bak
    fi
    ln -s "~/.zprezto/runcoms/${rc}" ~/${rc}
  done

  echo "Linking dot files..."
  for file in *.dot(N); do
    rc=".${file%.dot}"
    if [ -e ~/${rc} ]; then
      echo "Backing up ${rc} as ${rc}.bak"
      mv ~/${rc} ~/${rc}.bak
    fi
    ln -s ${DOTS}/${file} ~/${rc}
  done

  echo "Installing powerline fonts..."
  ./fonts/install.sh

  if hash gnome-terminal >/dev/null; then
    echo "Installing solarized theme for gnome-terminal..."
    ${DOTS}/solarized/gnome-terminal/solarize
  fi

  echo "Creating vim temp directories..."
  mkdir -p ~/.local/share/vim/swap
  mkdir -p ~/.local/share/vim/undo
  mkdir -p ~/.local/share/vim/backup

  echo "Creating ~/.custom directory. Create a gitconfig there"
  mkdir -p ~/.custom
  mkdir -p ~/.custom/vim
  ln -s ~/.custom/vim ${DOTS}/vim.dot/bundle/custom

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
      if read -q "REPLY?Install package $2? [y/N] "; then
        echo "\n"
        if sudo apt-get install $2; then
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
  if ! pip show $1 &>/dev/null; then
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
