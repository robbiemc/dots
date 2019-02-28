#!/bin/zsh
#
# Link dot files
#

setopt EXTENDED_GLOB

# Set DOTS to a default value if it's not set
${DOTS:=${HOME}/.dots}
if [[ ! -d ${DOTS} ]]; then
  print "${DOTS} does not exist!"
  exit 1
fi
cd ${DOTS}

print "Linking dot files..."
for file in *.dot(N); do
  rc=".${file%.dot}"
  if [[ -e ${HOME}/${rc} ]]; then
    print "Backing up ${rc} as ${rc}.bak"
    mv ${HOME}/${rc} ${HOME}/${rc}.bak
  fi
  ln -s ${DOTS}/$file ${HOME}/${rc}
done
