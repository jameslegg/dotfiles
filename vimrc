execute pathogen#infect()
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
" vim-airline settings
set laststatus=2
" airline should play nice with syntastic
let g:airline_enable_syntastic = 1
let g:airline_theme='dark'
" use pretty fonts from powerline
let g:airline_powerline_fonts = 1
" don't show mode in normal status line anymore
set noshowmode
" Setup colours to make airline work properly
set t_Co=256
"CoVim
let CoVim_default_name = "JamesLegg"
let CoVim_default_port = "9999"  
" Scroll before I reach the window edge
set scrolloff=2
"Spelling
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd FileType gitcommit setlocal spell
" Write files with sudo if opened without priviliedges
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
