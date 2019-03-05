# Solarized colors
typeset -Ag sfg sbg chr
# 8 color sequences
sfg=(
  base03  $'%{\e[01;30m%}'
  orange  $'%{\e[01;31m%}'
  base01  $'%{\e[01;32m%}'
  base00  $'%{\e[01;33m%}'
  base0   $'%{\e[01;34m%}'
  violet  $'%{\e[01;35m%}'
  base1   $'%{\e[01;36m%}'
  base3   $'%{\e[01;37m%}'
  base02  $'%{\e[22;30m%}'
  red     $'%{\e[22;31m%}'
  green   $'%{\e[22;32m%}'
  yellow  $'%{\e[22;33m%}'
  blue    $'%{\e[22;34m%}'
  magenta $'%{\e[22;35m%}'
  cyan    $'%{\e[22;36m%}'
  base2   $'%{\e[22;37m%}'
)
sbg=(
  base03  $'%{\e[01;40m%}'
  orange  $'%{\e[01;41m%}'
  base01  $'%{\e[01;42m%}'
  base00  $'%{\e[01;43m%}'
  base0   $'%{\e[01;44m%}'
  violet  $'%{\e[01;45m%}'
  base1   $'%{\e[01;46m%}'
  base3   $'%{\e[01;47m%}'
  base02  $'%{\e[22;40m%}'
  red     $'%{\e[22;41m%}'
  green   $'%{\e[22;42m%}'
  yellow  $'%{\e[22;43m%}'
  blue    $'%{\e[22;44m%}'
  magenta $'%{\e[22;45m%}'
  cyan    $'%{\e[22;46m%}'
  base2   $'%{\e[22;47m%}'
)
# 256 color sequences
# sfg=(
#   base02  $'%{\e[38;5;00m%}'
#   red     $'%{\e[38;5;01m%}'
#   green   $'%{\e[38;5;02m%}'
#   yellow  $'%{\e[38;5;03m%}'
#   blue    $'%{\e[38;5;04m%}'
#   magenta $'%{\e[38;5;05m%}'
#   cyan    $'%{\e[38;5;06m%}'
#   base2   $'%{\e[38;5;07m%}'
#   base03  $'%{\e[38;5;08m%}'
#   orange  $'%{\e[38;5;09m%}'
#   base01  $'%{\e[38;5;10m%}'
#   base00  $'%{\e[38;5;11m%}'
#   base0   $'%{\e[38;5;12m%}'
#   violet  $'%{\e[38;5;13m%}'
#   base1   $'%{\e[38;5;14m%}'
#   base3   $'%{\e[38;5;15m%}'
# )
# sbg=(
#   base02  $'%{\e[48;5;00m%}'
#   red     $'%{\e[48;5;01m%}'
#   green   $'%{\e[48;5;02m%}'
#   yellow  $'%{\e[48;5;03m%}'
#   blue    $'%{\e[48;5;04m%}'
#   magenta $'%{\e[48;5;05m%}'
#   cyan    $'%{\e[48;5;06m%}'
#   base2   $'%{\e[48;5;07m%}'
#   base03  $'%{\e[48;5;08m%}'
#   orange  $'%{\e[48;5;09m%}'
#   base01  $'%{\e[48;5;10m%}'
#   base00  $'%{\e[48;5;11m%}'
#   base0   $'%{\e[48;5;12m%}'
#   violet  $'%{\e[48;5;13m%}'
#   base1   $'%{\e[48;5;14m%}'
#   base3   $'%{\e[48;5;15m%}'
# )
chr=(
  branch    $'\ue0a0'
)

# Highlights the current directory in the PWD string
function prompt_harmonic_pwd {
  local pwd="${PWD/#$HOME/~}"
  local dir="$(basename ${PWD})"

  if [[ ${pwd} = "~" ]]; then
    _prompt_harmonic_pwd="${sfg[base0]}~%f"
  else
    # TODO: Truncate extra long paths
    _prompt_harmonic_pwd="${sfg[base01]}${pwd%${~dir}}${sfg[base0]}${dir}%f"
  fi
}

# Copies the vcs info into a variable that can be erased if there's no space
function prompt_harmonic_vcs {
  _prompt_harmonic_vcs=" ${vcs_info_msg_0_}"
}

# Changes the color of the prompt character based on privilege
function prompt_harmonic_prompt_char {
  _prompt_harmonic_prompt_char="%(!.${sfg[red]}#.${sfg[base1]}»)%f"
}

function prompt_harmonic_precmd {
  prompt_harmonic_pwd
  vcs_info
  prompt_harmonic_vcs
  prompt_harmonic_prompt_char
}

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats "${sfg[green]}${chr[branch]} %b%f"
zstyle ':vcs_info:git*' actionformats "${sfg[green]}${chr[branch]} %b%f:${sfg[red]}%a%f"

autoload -Uz add-zsh-hook
add-zsh-hook precmd prompt_harmonic_precmd

setopt prompt_subst
PROMPT='${sbg[base02]}${_prompt_harmonic_pwd}${_prompt_harmonic_vcs}%E
%k${_prompt_harmonic_prompt_char}%f '
RPROMPT='${sfg[base01]}%*'
