" Enable Pathogen (to load the plugins)
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()

" General settings
set hidden
set modelines=0
set hlsearch
set number
set relativenumber
set wildmode=list:longest

" Directories
set directory=~/.local/share/vim/swap//
set backupdir=~/.local/share/vim/backup//
set undodir=~/.local/share/vim/undo//

" Disable the arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Fix xterm-style keys in tmux
if &term =~ '^screen'
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

" Wrap long lines at break boundries
set wrap
set linebreak

" Tab Navigation
nmap Z :bp<cr>
nmap X :bn<cr>

" Custom commands
command Trim %s/\s\+$//

" Color Scheme
set background=dark
colorscheme solarized

" Airline configuration
let g:airline_theme='solarized'
let g:airline_solarized_bg='dark'
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1

" NERDTree configuration
let g:NERDTreeWinSize=50
let g:NERDTreeQuitOnOpen=1
nmap <C-h> :NERDTreeFind<cr>

" ctrl-p
nmap <C-p> :GitFiles<cr>

" YCM
set completeopt-=preview
let g:ycm_show_diagnostics_ui = 1
let g:ycm_enable_diagnostic_signs = 0
let g:ycm_enable_diagnostic_highlighting = 0

" Indentation
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

" Load vimrc customizations
if filereadable(expand('~/.custom/vimrc'))
  source ~/.custom/vimrc
endif

" Filetype dependent formatting
" Set .txt files to be of type human
augroup filetype
  autocmd BufNewFile,BufRead *.txt set filetype=human
augroup END
" Text files should automatically format to 80 characters
autocmd FileType mail,human set formatoptions+=t
" Use fancy indentation for C-like languages
autocmd FileType h,c,cpp,cc,cuda set cindent formatoptions+=ro colorcolumn=81
autocmd FileType h,c,cpp,cc,cs,java setlocal commentstring=//\ %s
" Use 4 space tabs and 100 character limit for java
autocmd FileType java set tabstop=4 shiftwidth=4 softtabstop=4 formatoptions+=ro colorcolumn=101 textwidth=100
" AIDL files are java-ish
autocmd BufNewFile,BufRead *.aidl setf java
" Use 4 space tabs for assembly and python files
autocmd FileType s,S,python set tabstop=4 shiftwidth=4 softtabstop=4
" Indent inside braces for perl and CSS
autocmd FileType perl, css set smartindent
" Kind of format HTML
autocmd FileType html set formatoptions+=tl
" Use literal tabs of 8 chars for Makefiles
autocmd FileType make set noexpandtab shiftwidth=8 tabstop=8
" Auto-copy comment headers for SML
autocmd FileType sml set formatoptions+=ro
" GLSL filetype defines
autocmd BufNewFile,BufRead *.frag,*.vert,*.glsl setf glsl
" .srcjar are zips
autocmd BufNewFile,BufRead *.srcjar setf zip
