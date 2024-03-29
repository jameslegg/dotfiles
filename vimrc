"tcalled from ~/.config/nvim/init.vim

set nocompatible              " be iMproved
filetype off                  " required!

" Installed using Plug
call plug#begin('~/.vim/plugged')

Plug 'bling/vim-airline'
Plug 'editorconfig/editorconfig-vim'
Plug 'tjdevries/colorbuddy.vim'
Plug 'Th3Whit3Wolf/onebuddy', { 'branch': 'main' }
" Plug 'neovim/nvim-lspconfig'
" Plug 'nvim-lua/completion-nvim'
Plug 'hashivim/vim-terraform'
" Plug 'juliosueiras/vim-terraform-completion'
Plug 'airblade/vim-gitgutter'
Plug 'elzr/vim-json'
Plug 'scrooloose/syntastic'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

call plug#end()

" mimic atom
set termguicolors
colorscheme onebuddy

" Languge server setup:
" https://coffeeandcontemplation.dev/2021/01/10/language-server-in-vim/
" luafile ~/dotfiles/lsp_config.lua

" Use completion-nvim in every buffer
" autocmd BufEnter * lua require'completion'.on_attach()

sign define LspDiagnosticsSignError text=🔴
sign define LspDiagnosticsSignWarning text=🟠
sign define LspDiagnosticsSignInformation text=🔵
sign define LspDiagnosticsSignHint text=🟢

nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gi    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> ge    <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>f    <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <leader>rn    <cmd>lua vim.lsp.buf.rename()<CR>

nnoremap <silent> <leader>a <cmd>lua vim.lsp.buf.code_action()<CR>
xmap <silent> <leader>a <cmd>lua vim.lsp.buf.range_code_action()<CR>

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect
" Snippets I *think* this should work with nvim-lua/completion-nvim ?
let g:completion_enable_snippet = 'UltiSnips'

" Avoid showing message extra message when using completion
set shortmess+=c

" python venv
" Set up using:
" curl https://pyenv.run | bash #YOLO
" pyenv virtualenv 2.7.17 neovim2
" pyenv activate neovim2
" pip install neovim
" pyenv virtualenv 3.9.5 neovim3
" pyenv activate neovim3
" pip install neovim
" pip install flake8
" pip intall 'python-lsp-server[all]'
let g:python_host_prog = '/Users/JamesL/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = '/Users/JamesL/.pyenv/versions/neovim3/bin/python'


imap <tab> <Plug>(completion_smart_tab)
imap <s-tab> <Plug>(completion_smart_s_tab)

filetype plugin indent on     " required!

"Don't hide json double quotes with vim-json
let g:vim_json_syntax_conceal = 0

" Set cloudformation .templates to json
au BufRead,BufNewFile *.template set filetype=json

"Terraform Completion minimal config
let g:terraform_align=1
let g:terraform_fold_sections=0
let g:terraform_remap_spacebar=1
let g:terraform_commentstring='//%s'
let g:terraform_fmt_on_save=1

" Minimal Configuration vim -completion
" Syntastic Config
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

" (Optional)Remove Info(Preview) window
set completeopt-=preview

" (Optional)Hide Info(Preview) window after completions
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" (Optional) Enable terraform plan to be include in filter
let g:syntastic_terraform_tffilter_plan = 1

" (Optional) Default: 0, enable(1)/disable(0) plugin's keymapping
let g:terraform_completion_keys = 1

" (Optional) Default: 1, enable(1)/disable(0) terraform module registry completion
let g:terraform_registry_module_completion = 0

" End terraform-completion

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
let g:syntastic_python_checker_args='--exclude=migrations --ignore=E261 --max-line-length=100'
"syntastic eslint
let g:syntastic_javascript_checkers=["eslint"]
"syntastic yamlint
let g:syntastic_yaml_checkers = ['yamllint']
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_quiet_messages = { "type": "style" }
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

" Highlight 101th column so code can still be pretty in full-screen terminals
if exists("&colorcolumn")
    set colorcolumn=101
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
