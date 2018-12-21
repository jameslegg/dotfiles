set nocompatible              " be iMproved
filetype off                  " required!

filetype plugin indent on     " required!

"Don't hide json double quotes with vim-json
let g:vim_json_syntax_conceal = 0

" Set cloudformation .templates to json
au BufRead,BufNewFile *.template set filetype=json

"Terraform
let g:terraform_align=1
let g:terraform_fold_sections=1
let g:terraform_remap_spacebar=1
let g:terraform_commentstring='//%s'
let g:terraform_fmt_on_save=1


let g:deoplete#omni_patterns = {}
let g:deoplete#omni_patterns.terraform = '[^ *\t"{=$]\w*'
let g:deoplete#enable_at_startup = 1
let g:python3_host_prog = '/Library/Frameworks/Python.framework/Versions/3.5/bin/python3'
"call deoplete#initialize()

set background=dark
set expandtab
set tabstop=4
set shiftwidth=4
map <F2> :retab <CR>
"syntax on
syntax enable
"syntastic
let g:syntastic_always_populate_loc_list=1
let g:syntastic_check_on_open=1
"syntastic python PEP8
let g:syntastic_python_checkers=['flake8', 'pyflakes', 'python']
let g:syntastic_python_checker_args='--exclude=migrations --ignore=E261 --max-line-length=80'
"syntastic eslint
let g:syntastic_javascript_checkers=["eslint"]
" vim-airline settings
set laststatus=2
" airline should play nice with syntastic
let g:airline_theme='dark'
" use pretty fonts from powerline
let g:airline_powerline_fonts = 1
" don't show mode in normal status line anymore
set noshowmode
" Setup colours to make airline work properly
set t_Co=256
" Scroll before I reach the window edge
set scrolloff=2
"Spelling
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd BufRead,BufNewFile *.txt setlocal spell
autocmd FileType gitcommit setlocal spell

" Write files with sudo if opened without privileges
cmap w!! w !sudo tee % >/dev/null

" Highlight 80th column so code can still be pretty in full-screen terminals
if exists("&colorcolumn")
    set colorcolumn=81
    hi ColorColumn guibg=#3d3d3d
endif


if has("autocmd")
    " Tell ruby files to use two spaces for indentation
    autocmd FileType ruby setlocal softtabstop=2 shiftwidth=2 tabstop=4
    " Tell json files to use two spaces for indentation
    autocmd FileType json setlocal softtabstop=2 shiftwidth=2 tabstop=4
    " Tell javascript files to use two spaces for indentation
    autocmd FileType javascript setlocal softtabstop=2 shiftwidth=2 tabstop=4
    " Tell coffeescript files to use two spaces for indentation
    autocmd FileType coffee setlocal softtabstop=2 shiftwidth=2 tabstop=4
    " Tell scala files to use two spaces for indentation
    autocmd FileType scala setlocal softtabstop=2 shiftwidth=2 tabstop=4
    " Makefiles use tabs only
    autocmd FileType make setlocal noexpandtab
    " Some types of files should wrap to 79 characters
    autocmd FileType tex setlocal textwidth=79
    autocmd FileType plaintex setlocal textwidth=79
    autocmd FileType latex setlocal textwidth=79
    autocmd FileType rst setlocal textwidth=79
    " Enable spell checking for latex and rst
    autocmd FileType tex setlocal spell spelllang=en_gb
    autocmd FileType plaintex setlocal spell spelllang=en_gb
    autocmd FileType latex setlocal spell spelllang=en_gb
    autocmd FileType rst setlocal spell spelllang=en_gb
    " Use pdflatex for compiling latex files
    autocmd FileType tex setlocal makeprg=pdflatex\ %
    " Don't do things like indent lines following lines that start with 'for'
    autocmd FileType tex setlocal nosmartindent
    autocmd FileType plaintex setlocal nosmartindent
    autocmd FileType latex setlocal nosmartindent
endif

"Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

call plug#begin()
" Vundle managed bundle
Plug 'gmarik/vundle'

" All my old pathogen vim plugins
Plug 'scrooloose/syntastic'
Plug 'bling/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'kchmck/vim-coffee-script'
Plug 'elentok/plaintasks.vim'
Plug 'terryma/vim-multiple-cursors'

" New stuff installed just with Vundle
Plug 'elzr/vim-json'
Plug 'hashivim/vim-terraform'

" VIM SnipMate
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'

" Optional:
Plug 'honza/vim-snippets'

Plug 'isRuslan/vim-es6'

Plug 'Shougo/deoplete.nvim',  { 'do': ':UpdateRemotePlugins' }

call plug#end()


