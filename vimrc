" my .vimrc
" This .vimrc aims to make Vim easier to use without making it
" too different from a stock Vim installation. This should feel
" comfortable to someone used to using vi.
"

" add the following to .profile or .bashrc
"export EDITOR=vim
"export VISUAL=vim
"export PAGER="col -b | view -c 'set ft=man nomod nolist nonumber' -"
"export MANPAGER="col -b | view -c 'set ft=man nomod nolist nonumber' -"

set nocompatible " use vim defaults (this should be first in .vimrc)
filetype plugin on " load ftplugin.vim
filetype indent on " load indent.vim

set history=1000 " number of commands and search patterns to save
set viminfo=!,%,'20,/100,:100,s100,n~/.viminfo " options for .viminfo
set paste " ignore autoindent and formatoptions while pasting. does not hurt gvim.
set binary " show control characters (ignore 'fileformat')
set noautoindent " do not auto indent
set shiftround " align to standard indent when shifting with < and >
set formatoptions+=r " auto-format comments while typing
    " t_Co=16 is good on OSX, but not on Linux (leave unset for default)
"set t_Co=16 " assume we have more colors to work with for highlighting
set background=dark " set terminal background (see F11)
set guifont="Inconsolata 9" set gvim font on Windows
syntax on " use syntax color highlighting
"colo ps_color " color scheme in ~/.vim/colors
"set visualbell " flash instead of beep -- this can be annoying
"set visualbell t_vb= " no beep or flash
"set mouse=a " enable VIM mouse (see map for F12)
set ttyfast " smoother display on fast network connections
set whichwrap=b,s,<,>,[,],~ " allow most motion keys to wrap
set backspace=indent,eol,start " allow bs over EOL, indent, and start of insert
set incsearch " incremental search
set nojoinspaces " use only one space when using join
set matchpairs+=<:> " add < > to chars that form pairs (see % command)
set showmatch " show matching brackets by flickering cursor
set matchtime=1 " show matching brackets quicker than default
set autoread " automatically read file changed outside of Vim
set autowrite " automatically save before commands like :next and :make
set splitbelow " open new split windows below the current one
set noequalalways " do not resize windows on split/close
"set shortmess="" " long messages -- does not seem to work
set showcmd " show partial command in status line
set suffixes+=.class,.pyc " skip bytecode files for filename completion
set suffixes-=.h " do not skip C header files for filename completion
set wrap " wrap long lines (no sidescroll)
set showbreak="" " string to put at the start of lines that have been wrapped
set listchars=tab:!-,trail:~ " strings to use in 'list' mode
" set backup " backup files before editing
" set backupdir=~/tmp,.,/tmp,/var/tmp " backup locations
set dir=~/tmp,.,/tmp,/var/tmp " swap file locations
set virtualedit=block " allow Visual block select anywhere
" show filename(no path) set statusline=%2B\ [%3c,%3l]\ %3p%%\ %t\ %m%r%w
set statusline=%2B\ [%3c,%3l]\ %3p%%\ %f\ %m%r%w
"%{strftime(\"%Y-%m-%d\ %H:%M\")}
"map <leader>d :echo strftime("%Y-%m-%d %H:%M:%S")<CR>
set laststatus=1 " show statusline in split windows
set rulerformat=%40(%2B\ [%3c,%3l]\ %3p%%\ %t\ %m%r%w%)
set ruler " show ruler
set nonumber " no line numbers
"set printoptions=number:y " put line numbers on hardcopy
" this turns on hlsearch, but clears the highlighting when Enter is hit
set wildmenu " show a menu of matches when doing completion
set hlsearch " highlight the current search pattern
nnoremap <silent><CR> :nohlsearch<CR><CR> " in normal mode enter clears search highlight
if version >= 700
    set numberwidth=4 " width of line numbers
endif

"
" tab settings
"
set tabstop=4|set shiftwidth=4|set expandtab " default
autocmd FileType python set tabstop=4|set shiftwidth=4|set expandtab " Python
autocmd FileType make set tabstop=8|set shiftwidth=8|set noexpandtab " Makefile
autocmd FileType man set tabstop=8|set shiftwidth=8|set noexpandtab " Man page (also used by psql to edit or view)
autocmd FileType calendar set tabstop=8|set shiftwidth=8|set noexpandtab

" This was just too clever and never worked quite right.
" I still want something like this, so I keep it here in case
" I ever figure out a smarter way of doing this.
" use magictab
"inoremap <tab> <c-r>=MagicTabWrapper("forward")<cr>
"inoremap <s-tab> <c-r>=MagicTabWrapper("backward")<cr>

" This highlights suspicious whitespace.
"autocmd FileType * :call HighlightBadWS()

" These are used by the DirDiff plugin.
let g:DirDiffExcludes = ".svn,*.jpg,*.png,*.gif,*.swp,*.a,*.so,*.o,*.pyc,*.exe,*.class,CVS,core,a.out"
let g:DirDiffIgnore = "Id:,Revision:,Date:"

"
" maps
"

" the default q: is totally stupid.
map q: :q

" map Q as @q (replay recording named q).
" I always use q as my ad-hoc, throw-away recording name, so
" I start recording with "qq" then reply the recording with "Q".
nnoremap Q @q

" easy indentation in visual mode
vmap > >gv
vmap < <gv

" spell check
" <F2> or \s
if version >= 700
  " map <silent><F2> <ESC>:set spell!<CR>
    map <silent><leader>s <ESC>:set spell!<CR>
    "setlocal spell spelllang=en_us
else " older versions use external aspell
    map <silent><F2> <ESC>:!aspell -c "%"<CR>:edit! "%"<CR>
    map <silent><leader>s <ESC>:!aspell -c "%"<CR>:edit! "%"<CR>
endif

" tab support
if version >= 700
    map <S-left> :tabp<CR>
    map <S-right> :tabn<CR>
endif

" redraw window
" <F5>
map <silent><F5> :redraw!<CR>

" This runs the current buffer in an X terminal that disappears after 5 minutes.
" This needs the env var $TERM set to xterm or some compatible X11 terminal.
" This does not save first!
" <F7> or \r
function RunBufferInTerm ()
    if &filetype == 'python'
        silent !$TERM -bg black -fg green -e bash -c "python %; sleep 300" &
    elseif &filetype == 'sh'
        silent !$TERM -bg black -fg green -e bash -c "./%; sleep 300" &
    elseif &filetype == 'php'
        silent !$TERM -bg black -fg green -e bash -c "php %; sleep 300" &
    elseif &filetype == 'perl'
        silent !$TERM -bg black -fg green -e bash -c "perl %; sleep 300" &
    endif
    sleep 1
    redraw!
endfunction
map <silent><F7> :call RunBufferInTerm()<CR>
map <silent><leader>r :call RunBufferInTerm()<CR>

" yank all lines
" <F8> or \a
map <silent><F8> gg"+yG
map <silent><leader>a gg"+yG
" toggle line numbers
" <F10> or \n
map <silent><F10> :set number!<CR>
map <silent><leader>n :set number!<CR>
" toggle between dark and light backgrounds
" <F11>
map <silent><F11> :let &background=(&background == "dark"?"light":"dark")<CR>
" toggle mouse mode between VIM and xterm
" <F12>
function ShowMouseMode()
    if (&mouse == 'a')
        echo "MOUSE VIM"
    else
        echo "MOUSE X11"
    endif
endfunction
map <silent><F12> :let &mouse=(&mouse == "a"?"":"a")<CR>:call ShowMouseMode()<CR>

" This is now covered by the DirDiff plugin.
" extra diff support
"
"map <silent><leader>dp :diffput<CR>
"map <silent><leader>dg :diffget<CR>

" run Vim diff on HEAD copy in SVN.
map <silent><leader>ds :call SVNDiff()<CR>
function! SVNDiff()
   let fn = bufname("%")
   let newfn = fn . ".HEAD"
   let catstat = system("svn cat " . fn . " > " . newfn)
   if catstat == 0
      execute 'vert diffsplit ' . newfn
   else
      echo "*** ERROR: svn cat failed for " . fn . " (as " . newfn . ")"
   endif
endfunction

"
" folding using the current /search/ pattern -- very handy!
"
" \z
" This folds every line that does not contain the search pattern.
" So the end result is that you only see lines with the pattern
" see vimtip #282 and vimtip #108
"map <silent><leader>z :set foldexpr=getline(v:lnum)!~@/ foldlevel=0 foldcolumn=0 foldmethod=expr<CR>
map <silent><leader>z :set foldexpr=(getline(v:lnum)=~@/)?\">1\":\"=\" foldlevel=0 foldcolumn=0 foldmethod=expr<CR>
" space toggles the fold state under the cursor.
nnoremap <silent><space> :exe 'silent! normal! za'.(foldlevel('.')?'':'l')<CR>
" this folds all classes and functions to create a code index.
" mnemonic: think "function fold"
map <silent>zff :set foldexpr=UniversalFoldExpression(v:lnum) foldmethod=expr foldlevel=0 foldcolumn=0<CR><CR>
function UniversalFoldExpression(lnum)
    if a:lnum == 1
        return ">1"
    endif
    return (getline(a:lnum)=~"^\\s*public function\\s\\|^\\s*function\\s\\|^\\s*class\\s\\|^\\s*def\\s") ? ">1" : "="
endfunction
" This doesn't work quite right:
    "if &filetype == 'php'
    "    if getline(a:lnum) =~ '/\*\*'
    "        call cursor(a:lnum,1)
    "        let sp = searchpair ('/\*\*','','\*/')
    "        call cursor(sp,1)
    "        let ax = search ('\n*\s*function','cW')
    "        if ax != 0
    "            return ">1"
    "        endif
    "    endif
    "    return "="
    "endif
    " @/ is the register that holds the last search pattern.

" plugins
runtime ftplugin/man.vim " allow vim to read man pages

"
" type \doc to insert PHPdocs
" see vimtip #1355
"
augroup php_doc
au!
"autocmd BufReadPost *.php,*.inc source ~/.vim/php-doc.vim
autocmd BufReadPost *.php,*.inc nnoremap <leader>doc :call PhpDocSingle()<CR>
autocmd BufReadPost *.php,*.inc vnoremap <leader>doc :call PhpDocRange()<CR>
augroup END


"
" This sets mouse support for editing XPM images in gvim.
" see h: xpm
"
function! GetPixel()
    let c = getline(".")[col(".") - 1]
    echo c
    exe "noremap <LeftMouse> <LeftMouse>r".c
    exe "noremap <LeftDrag>  <LeftMouse>r".c
endfunction
autocmd BufReadPre *.xpm noremap <RightMouse> <LeftMouse>:call GetPixel()<CR>
autocmd BufReadPre *.xpm set guicursor=n:hor20 " to see the color under cursor

"
" Experimental stuff
"

function! AppendUnnamedReg()
    let old=@"
    yank
    let @" = old . @"
endfun

" online doc search
map <silent><M-d> :call OnlineDoc()<CR>
function! OnlineDoc()
    if &ft =~ "cpp"
        let s:urlTemplate = "http://doc.trolltech.com/4.1/%.html"
    elseif &ft =~ "ruby"
        let s:urlTemplate = "http://www.ruby-doc.org/core/classes/%.html"
    elseif &ft =~ "php"
        let s:urlTemplate = "http://www.php.net/%"
    elseif &ft =~ "perl"
        let s:urlTemplate = "http://perldoc.perl.org/functions/%.html"
    elseif &ft =~ "python"
        let s:urlTemplate = "http://starship.python.net/crew/theller/pyhelp.cgi?keyword=%"
    else
        return
    endif
    let s:browser = "firefox"
    let s:wordUnderCursor = expand("<cword>")
    let s:url = substitute(s:urlTemplate, "%", s:wordUnderCursor, "g")
    let s:cmd = "silent !" . s:browser . " " . s:url
    execute  s:cmd
    redraw!
endfunction

" simple calculator based loosely on vimtip #1349
" control the precision with this variable
let g:MyCalcPresition = 2
function MyCalc(str)
    return system("echo 'scale=" . g:MyCalcPresition . " ; print " . a:str . "' | bc -l")
endfunction
" Use \C to replace a math expression by the value of its computation
vmap <leader><silent>C :s/.*/\=MyCalc(submatch(0))/<cr>/<BS>
vmap <leader><silent>C= :B s/.*/\=submatch(0) . " = " . MyCalc(submatch(0))/<cr>/<BS>

" Python command Calc based on vimtip #1235
" does NOT use built-in vim python
command! -nargs=+ Calc :r! python -c "from math import *; print <args>"

" allow reading of PDF text documents
" On Ubuntu install the xpdf-utils deb package.
autocmd BufReadPre *.pdf set ro
autocmd BufReadPost *.pdf silent %!pdftotext -nopgbrk "%" - |fmt -csw78

" allow reading of MS Word doc documents
" on Ubuntu install the antiword deb package.
autocmd BufReadPre *.doc set ro
autocmd BufReadPost *.doc silent %!antiword -i 1 -s -f "%" - |fmt -csw78

" vimtip #1354
function! OnlineDoc()
    let s:browser = "firefox"
    let s:wordUnderCursor = expand("<cword>")
    if &ft == "cpp" || &ft == "c" || &ft == "ruby" || &ft == "php" || &ft == "python"
        let s:url = "http://www.google.com/codesearch?q=".s:wordUnderCursor."+lang:".&ft
    elseif &ft == "vim"
        let s:url = "http://www.google.com/codesearch?q=".s:wordUnderCursor
    else
        return
    endif
    let s:cmd = "silent !" . s:browser . " " . s:url
    "echo  s:cmd
    execute  s:cmd
endfunction
" online doc search
map <LocalLeader>k :call OnlineDoc()<CR>

" jump to the last known position in a file
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

set nocompatible
filetype on
filetype indent on
filetype plugin on
set shiftwidth=2
set tabstop=2
set smarttab
set expandtab
set softtabstop=2
set laststatus=2
set iskeyword+=.
set statusline=%<%f\%h%m%r%=%-20.(line=%l\ \ col=%c%V\ \ totlin=%L%)\ \ \%h%m%r%=%-40(bytval=0x%B,%n%Y%)\%P
syntax on
set ai
set nu


" minibuff explorer

"let g:miniBufExplMapWindowNavVim = 1
"let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
"let g:miniBufExplModSelTarget = 1
let g:miniBufExplorerMoreThanOne = 0
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplVSplit = 25
"let g:miniBufExplSplitBelow=1
" F3 open taglist
nnoremap <silent> <F3> :TlistToggle<CR>
" F4 or \bt open nerdtree
nnoremap <silent> <F4> :NERDTreeToggle<CR>
map <silent> <unique> <Leader>bt :NERDTreeToggle<CR>

let g:bufExplorerDefaultHelp = 1
"let g:bufExplorerSplitBelow = 1
let g:bufExplorerOpenMode = 1
let g:bufExplorerSplitHorzSize = 7
nnoremap <silent> <F2> :TMiniBufExplorer<cr>

"move between buffers
set hidden
map <C-Up> :bn<cr>:redraw<cr>
map <C-Down> :bp<cr>:redraw<cr>

"copy/paste text from other editors
":set tw=0 wrap linebreak
"
"fuzzyfinder plugin
"
map <leader>b :FuzzyFinderBuffer<CR>
map <leader>f :FuzzyFinderFile<CR>

" bind tab with omnicomplete yay !
let g:SuperTabDefaultCompletionType = "<C-X><C-O>"
"change omnicomplete color
highlight Pmenu guibg=brown gui=bold

color zenburn
