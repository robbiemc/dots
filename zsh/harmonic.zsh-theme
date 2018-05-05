# ---------------------------------------------------------------------
# harmonic.zsh-theme
# Robbie McElrath (robbiemcelrath@gmail.com)
#
# Based on wavelength, by:
# Billy Keyes (http://bluekeyes.com/)
# ---------------------------------------------------------------------

# Load the solarized colors
solarized

#
# Highlights the current directory in the PWD string
#
function highlighted_pwd() {
    local dir home_sub

    dir="$(basename ${PWD})"
    home_sub="${PWD/#$HOME/~}"

    if [[ ${home_sub} = "~" ]]; then
        echo "${slr_fg[base0]}~"
    else
        # TODO truncate extra long working directories
        echo "${home_sub%${~dir}}${slr_fg[base0]}${dir}"
    fi
}

#
# Switches color and character based on privildege
#
function prompt_char() {
    echo "%(!.${slr_fg[red]}#.${slr_fg[base1]}»)%{$reset_color%}"
}

PROMPT='${slr_bg[base03]}${slr_fg[yellow]}${slr_fg[base01]}$(highlighted_pwd)${slr_fg[base01]} $(git_prompt_info)%E
%{$reset_color%}$(prompt_char) '

RPROMPT='${slr_fg[base01]}%*%{$reset_color%}'
if [[ -n ${SSH_CONNECTION} ]]; then
    RPROMPT="${slr_fg[blue]}%n@%m${slr_fg[base0]} | ${RPROMPT}"
fi
