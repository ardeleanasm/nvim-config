" Plugins
call plug#begin('~/.config/nvim/plugged')

" Tools
    Plug 'airblade/vim-gitgutter'
    Plug 'scrooloose/nerdtree'
"   Plug 'vivien/vim-linux-coding-style'
" Syntax
    Plug 'tpope/vim-markdown'
    Plug 'ap/vim-css-color' "Displays a preview of colors with CSS
    Plug 'vim-scripts/fountain.vim'
" Theme
    Plug 'arcticicestudio/nord-vim'
"Format
    Plug 'sbdchd/neoformat'
"Vimwiki
    Plug 'vimwiki/vimwiki'
" Airline
    Plug 'vim-airline/vim-airline'
call plug#end()


"Settings

set encoding=UTF-8
set nocompatible
filetype plugin on
syntax on  "Turning Syntax on

set autoread wildmode=longest,list,full
set spell spelllang=en_us
set backspace=indent,eol,start confirm
set hls is ic
set laststatus=2 cmdheight=1
			
set splitbelow splitright
setlocal foldmethod=indent
set foldlevel=5
set cindent
set shiftwidth=4
set number
set comments=sl:/*,mb:*,elx:*/
set clipboard^=unnamed,unnamedplus

"Theme settings
set cursorline
set t_Co=256
colorscheme nord

"Find files
set path+=**

"Display all matching
set wildmenu

"Airline configuration
function! GitStatus()
  let [a,m,r] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', a, m, r)
endfunction
function! AirlineInit()
  let g:airline#extensions#hunks#enabled=0
  let g:airline#extensions#branch#enabled=1
  let g:airline_section_a = airline#section#create(['mode',' ','branch'])
  let g:airline_section_b = airline#section#create_left(['ffenc','hunks','%f'])
  let g:airline_section_c = airline#section#create(['filetype'])
  let g:airline_section_x = airline#section#create(['%P'])
  let g:airline_section_y = airline#section#create(['%B'])
  let g:airline_section_z = airline#section#create_right(['%l/%n','%c'])
endfunction

autocmd VimEnter * call AirlineInit()

"let g:airline_statusline_ontop=1


"Status-line
"set statusline=
"set statusline+=%#IncSearch#
"set statusline+=\ %y
"set statusline+=\ %r
"set statusline+=%#CursorLineNr#
"set statusline+=\ %F
"set statusline+=%= "Right side settings
"set statusline+=%#Search#
"set statusline+=\ %l/%n
"set statusline+=\ [%c]

"Key bindings
"configure key leader to space
let mapleader = "\<Space>"

"configure shortcut for NerdTreeToggle
map <C-o> :NERDTreeToggle

"configure shortcuts for resizing
nnoremap <C-Up> :resize +2<CR>
nnoremap <C-Down> :resize -2<CR>
nnoremap <C-Left> :vertical resize +2<CR>
nnoremap <C-Right> :vertical resize -2<CR>

"configure shortcut for reloading MYVIMRC
nnoremap <C-R> :so $MYVIMRC <CR>



"noremap <F3> :Autoformat<CR>

"configure shortcut for moving lines up/down
noremap <M-Down> :normal! ddpmm<CR>
noremap <M-Up> :normal! ddkkpmm<CR>

"spell check
function FixLastSpellingError()
    normal! mm[s1z=`m
endfunction
nnoremap <Leader>sp :call FixLastSpellingError()<CR>

"Ctags configuration
noremap <C-c> :! ctags -R . <CR><CR>
noremap <C-Del> :! del /f tags <CR><CR>

"Auto Update ctags

function! DelTagOfFile(file)
  let fullpath = a:file
  let cwd = getcwd()
  let tagfilename = cwd . "/tags"
  let f = substitute(fullpath, cwd . "/", "", "")
  let f = escape(f, './')
  let cmd = 'sed -i "/' . f . '/d" "' . tagfilename . '"'
  let resp = system(cmd)
endfunction

function! UpdateTags()
  let f = expand("%:p")
  let cwd = getcwd()
  let tagfilename = cwd . "/tags"
  let cmd = 'ctags -a -f ' . tagfilename . ' --c++-kinds=+p --fields=+iaS --extra=+q ' . '"' . f . '"'
  call DelTagOfFile(f)
  let resp = system(cmd)
endfunction
autocmd BufWritePost *.cpp,*.h,*.c call UpdateTags()



"Gitgutter configuration
set updatetime=100  "updatetime of 100ms from modification done to show changed icon
map <C-g> :GitGutterToggle


"Formatting c/c++ code
let g:neoformat_cpp_clangformat = {
    \ 'exe': 'clang-format',
    \ 'args': ['--style="{IndentWidth: 4}"']
\}
let g:neoformat_enabled_cpp = ['clangformat']
let g:neoformat_enabled_c = ['clangformat']
