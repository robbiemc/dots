# Editors
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'

# Language
if [[ -z "${LANG}" ]]; then
  export LANG='en_US.UTF-8'
fi

# Path
# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path
export PATH=${PATH}:${HOME}/bin

if [[ -e ${HOME}/.custom/zshenv ]]; then
  source ${HOME}/.custom/zshenv
fi
