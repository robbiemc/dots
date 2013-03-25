#!/bin/zsh
#
# Installs dot files
#

DOTS=~/.dots
if [ -d ${DOTS} ]; then
  echo "Dot file are already installed. Delete your ${DOTS} directory and try again."
  exit 1
fi

echo "Cloning dots..."
hash git >/dev/null && /usr/bin/env git clone git@github.com:robbiemc/dots.git ${DOTS} || {
  echo "git not installed"
  exit 1
}

echo "Switching to dots directory..."
cd ${DOTS}

echo "Initializing submodules..."
/usr/bin/env git submodule init && /usr/bin/env git submodule update || {
  echo "Failed to setup dots submodules"
  exit 1
}

echo "Linking rc files..."
for file in *.dot(N); do
  rc=".${file%.dot}"
  if [ -e ~/${rc} ]; then
    echo "Backing up ${rc} as ${rc}.bak"
    mv ~/${rc} ~/${rc}.bak
  fi
  ln -s ${DOTS}/${file} ~/${rc}
done

# Make vim temp directories if they don't exist
mkdir -p ~/.local/share/vim/swap
mkdir -p ~/.local/share/vim/undo
mkdir -p ~/.local/share/vim/backup

echo "Creating ~/.custom directory. Create a gitconfig there"
mkdir -p ~/.custom

echo "Dot files installed! Restart your shell."
