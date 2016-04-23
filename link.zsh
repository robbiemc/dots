#!/bin/zsh
#
# Link dot files
#

setopt EXTENDED_GLOB

# Set DOTS to a default value if it's not set
cd ${DOTS:=$HOME/.dots}

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
