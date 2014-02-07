" ~/.vimrc
" Tobias V. Langhoff (tobiasvl@ifi.uio.no / spug@thespug.net) put this together
" from bits and pieces stolen from lots of other people.
"
" Modified by Thomas Misund (thomas@hemmeligadresse.com / 
" http://hemmeligadresse.com/).

call pathogen#infect()

filetype indent on

" misc
syntax enable       " enable syntax highlighting
set ruler           " show line info
set laststatus=2    " always show statusbar
set showcmd         " show partially typed commands
set showmode        " show the current mode
set mouse=a         " enable mouse (hold shift for regular xterm mouse action)
set backspace=2     " make backspace sane (set backspace=eol,start,indent ?)
"set gdefault        " imply g (entire line) when searching and replacing
set whichwrap=b,s,h,l,~,[,],<,> " wrap to the next line with these keys
set showmatch       " briefly jump to matching parenthesis when writing one
set matchpairs=(:),{:},[:],<:>  " match these with eachother (%)
set wrap            " wrap long lines
set showbreak=>>     " display this at the start of wrapped lines
set noendofline     " don't write <EOL> at the end of file
set cursorline      " highlight the current line
let html_use_css=1  " use CSS when doing a :TOhtml
let use_xhtml=1     " use XHTML when doing a :TOhtml o/~
set encoding=utf-8  " set encoding to utf-8
set gfn=Monospace\ 9  " set font and font-size

" search
set hlsearch        " highlight search terms
set incsearch       " search while typing
set ignorecase      " ignore case when searching ...
set smartcase       " ... except when the search term specifically contains uppercase

" colors
"colorsche desert    " best color schemes: peachpuff, default, elflord, desert
colorsche misunddesert
highlight LineNr              ctermfg=darkgrey              guifg=darkgrey
"highlight Comment            ctermfg=darkblue
"highlight ModeMsg cterm=NONE ctermfg=white                 guifg=white
"highlight Search             ctermfg=0        ctermbg=3    guifg=Black    guibg=Yellow
"highlight Pmenu                               ctermbg=blue                              cterm=bold

" indenting
set autoindent      " auto-indent new lines
set smartindent     " auto-indent things in braces
"set expandtab       " away with those pesky tabs
set noexpandtab     " some say real code deserves real tabs
set shiftwidth=4    " number of spaces per indent level
set softtabstop=4   " number of spaces to e.g. delete with backspace
set cindent         " auto-indent things in braces, loops, conditions, etc.
set formatoptions+=ro   " keep indenting block comments
"set tabstop=4       " set tab to four spaces' length (should be avoided)

" Boilerplate
abbr psvm public static void main((String[] args) {
abbr sop System.out.println

" keymapping
" turn line numbers on
set number
" toggle line numbers
nnoremap \tn :set invnumber number?<CR>
nmap <F3> \tn
imap <F3> <C-O>\tn
" Set shortkeys for paste, so several lines can be pasted without indentation problems
nnoremap \tp :set invpaste paste?<CR>
nmap <F4> \tp
imap <F4> <C-O>\tp
set pastetoggle=<F4>
" Turn off highlight search
nnoremap <silent> <Space> :silent noh<Bar>echo<CR>
" Toggle word wrap
nnoremap \tw :set invwrap wrap?<CR>
nmap <F7> \tw
imap <F7> <C-O>\tw
" Toggle current line highlighting (because it's pretty slow)
nnoremap \tc :set invcul cul?<CR>
nmap <F8> \tc
imap <F8> <C-O>\tc
" Toggle spellchecking
nnoremap \ts :set invspell spell?<CR>
nmap <F9> \ts
imap <F9> <C-O>\ts
" Eclipse-like
inoremap ( ()<Left>
inoremap (( (
inoremap () ()
inoremap (* (*  *)<Left><Left><Left>
inoremap {  {<CR>}<Esc>O
inoremap {{ {
inoremap {} {}
au BufRead      if &ft != 'vim' | inoremap " ""<Left>| endif

" HTML entities
au FileType html imap Ø &Oslash;
au FileType html imap Å &Aring;
au FileType html imap Æ &AElig;
au FileType html imap ø &oslash;
au FileType html imap å &aring;
au FileType html imap æ &aelig;

" Filetype-specific autocommands.
" Most importantly: Comment in and out lines using - and _ respectively.
" Found on vim.org some time.
" The different FileTypes can be found in /usr/share/vim/vim70/filetype.vim
filetype on         " detect filetypes
augroup vimrc_filetype
    autocmd!
    autocmd FileType    make        set softtabstop=0 noexpandtab shiftwidth=8    " Makefiles need real tabs
    autocmd FileType    helpfile    nnoremap <buffer><cr> <c-]>     " Enter selects subject
    autocmd FileType    helpfile    nnoremap <buffer><bs> <c-T>     " Backspace to go back
    " Highlight characters exceeding 80:
    hi LineTooLong ctermfg=red ctermbg=darkgray guibg=LightYellow
    autocmd FileType    c,java      :match LineTooLong /\%>80v.\+/
    " Comment lines with -
    autocmd FileType    c,cpp,java,php  map - :s/^/\/\//<CR>:nohlsearch<CR>
    autocmd FileType    vim         map - :s/^/\"/<CR>:nohlsearch<CR>
    autocmd FileType    ruby        map - :s/^/#/<CR>:nohlsearch<CR>
    autocmd FileType    xdefaults   map - :s/^/!/<CR>:nohlsearch<CR>
    autocmd FileType    lisp,scheme map - :s/^/;/<CR>:nohlsearch<CR>
    " Add a shortkey for compiling and running the current Java program. Less
    " than ideal for now: doesn't stop if javac returns an error, and doesn't
    " support arguments.
    autocmd FileType    java        nmap <F5> :w<CR>:!javac %<CR>:!java %:r<CR>
    autocmd FileType    html        nmap <F5> :w<CR>:!opera %<CR>
    autocmd FileType    sml         nmap <F5> :w<CR>:!sml %<CR>
    autocmd FileType    scheme,lisp      set lisp
    " Automatically chmod +x Shell and Perl scripts
    autocmd BufWritePost   *.sh     !chmod +x %
    autocmd BufWritePost   *.pl     !chmod +x %
    " Automatically source
    autocmd BufWritePost   ~/.vimrc  :source %
    autocmd BufWritePost   ~/.bashrc :!source %
augroup end

" Uncomment lines with _ (one rule for all languages)
map _ :s/^\/\/\\|^--\\|^> \\|^[#"%!;]//<CR>:nohlsearch<CR>

"" defining a function - call it with call functionname()
"function! s:SomeSettings()
"endfunction

" .rst files require weird tabstops
autocmd Filetype rst setlocal expandtab
autocmd Filetype rst setlocal tabstop=3
autocmd Filetype rst setlocal shiftwidth=3
