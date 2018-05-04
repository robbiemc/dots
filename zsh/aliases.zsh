# Removes oh-my-zsh aliases I don't use
unalias cd..
unalias cd...
unalias cd....
unalias cd.....
unalias cd/
unalias gb

# Custom aliases
alias dus='du -sk | sort -n'
alias sml='rlwrap sml'
alias gdb='gdb -silent'
alias vim='vim -p'
alias mcm='make clean && make'
alias br='git branch'
alias st='git st'

function mkcdir () {
  if [[ $# == 1 ]]; then
    mkdir -p $1
    cd $1
  else
    print "Usage: mkcdir <directory>"
  fi
}
