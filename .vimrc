set nocompatible " be improved, required
filetype off     " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
" Plugin 'kien/rainbow_parenteses.vim' " 括号增强色彩
Plugin 'scrooloose/nerdtree'
Plugin 'valloric/youcompleteme'
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'scrooloose/syntastic' " syntax highlight
Plugin 'tpope/vim-fugitive'   " git
Plugin 'bling/vim-bufferline' " 显示在airline里的buffer
Plugin 'trailing-whitespace'  " 增加尾部空格的显示
Plugin 'bling/vim-airline'    " 状态栏
Plugin 'vim-airline/vim-airline-themes'
Plugin 'Smooth-Scroll'        " 平滑滚动
Plugin 'commentary.vim'       " 注释多行
Plugin 'Raimondi/delimitmate' " 括号引号等自动补全
Plugin 'tpope/vim-surround'   " Surround.vim is all about 'surroundings':parentheses, brackets, quotes, XML tags, and more. The plugin provides mappings to easily delete, change and such surrounding in pairs.
Plugin 'mattn/emmet-vim'

" All of your Plugins must be added before the following line
call vundle#end()
filetype plugin indent on

" Vim UI
set background=dark
set termguicolors
colorscheme quantum

" brief help
" :PluginList  - List configured plugins
" :PluginInstall - Install plugins; append '!' to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append '!' to refresh local cache
" :PluginClean  - confirms removal of unused plugins; append '!' to
" auto-approve removal
" Put your non-Plugin stuff after this line

" Default Indentation
set autoindent
set smartindent   " indent when
set tabstop=4     " tab width
set softtabstop=4 " backspace delete indent
set shiftwidth=4  " indent width
set backspace=2

syntax enable
set number
set cursorline    " 突出显示当前行
set cursorcolumn  " 突出显示当前列
" set pastetoggle=<F9> " 粘贴不带缩进

" emmet configuration
" enable just for html/css
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
" Note that the trailing, still needs to be entered, so the new keymap would
" be <C-Z>,
let g:user_emmet_leader_key='<C-Z>'

" NERDTree configuration
" map a specific key or shortcut to open NERDTree
map <F2> :NERDTreeToggle<CR>
" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" 关闭最后窗口时同时关闭nerdtree
autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()
" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
function! s:CloseIfOnlyNerdTreeLeft()
	if exists("t:NERDTreeBufName")
		if bufwinnr(t:NERDTreeBufName) != -1
			if winnr("$") == 1
				q
			elseif winnr("$") == 2
				if bufwinnr("__Tag_List__") != -1
					q
				endif
			endif
		endif
	endif
endfunction
let g:NERDTreeWinPos='right' " NERDTree open on the right side

" powerline configuration iterms
set t_Co=256   " color support
set encoding=utf-8
set laststatus=2   " Always show statusline
set term=xterm-256color
set termencoding=utf-8
let g:Powerline_symbols="fancy"  " fancy symbols

" python with virtualenv support
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF

" Tagbar configuration
let g:tagbar_ctags_bin='/usr/local/Cellar/ctags/5.8_1/bin/ctags'  " proper ctags location, required
let g:tagbar_width=26   " Default is 40
nmap <F8> :TagbarToggle<CR>
let g:tagbar_left=1

" <F5>编辑运行
func! CompileRun()
	exec "w"
	if &filetype == 'python'
		exec "!time python %"
    elseif &filetype == 'c'
		exec "!g++ % -o %<"
        exec "!time ./%<"
		exec "!rm ./%<"
    elseif &filetype == 'java'
		exec "!java %"
		exec "!time java %<"
		exec "!rm ./%<.class"
    elseif &filetype == 'html'
		exec "!chrome % &"
	endif
endfunc

" airline configuration
let g:airline_theme="powerlineish"
let g:airline_powerline_fonts=1

" 新建.c,.h,.sh,.java文件，自动插入文件头
autocmd BufNewFile *.md exec ":call Setmd()"
func Setmd()
    call setline(1,"date: ".strftime("%Y-%m-%d %T"))
    call append(line("."),"tags: ")
    call append(line(".")+1,"---")
    call append(line(".")+2,"")
endfunc
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.py,*.html,*.php,*java exec ":call SetTitle()"
 ""定义函数SetTitle，自动插入文件头
func SetTitle()
    if &filetype=='python'
        call setline(1, "#-*- encoding: UTF-8 -*-")
        call append(line("."), "#---------------------------------import------------------------------------")
        call append(line(".")+1, "#---------------------------------------------------------------------------")
        call append(line(".")+2, "############################################################################")
    endif
    if &filetype=='sh'
        call setline(1,"\#########################################################################")
        call append(line("."), "\# File Name: ".expand("%"))
        call append(line(".")+1, "\# Author: limbo")
        call append(line(".")+2, "\# mail: 468137306@qq.com")
        call append(line(".")+3, "\# Created Time: ".strftime("%c"))
        call append(line(".")+4, "\# Last changed:  TIMESTAMP")
        call append(line(".")+5, "\#########################################################################")
        call append(line(".")+6, "\#!/bin/bash".expand("%"))
        call append(line(".")+7, "")
    endif
    if &filetype=='html' || &filetype=='php'
        call setline(1, "<!--*************************************************************************")
        call append(line("."), "      > File Name: ".expand("%"))
        call append(line(".")+1, "      > Author: limbo")
        call append(line(".")+2, "      > Mail: 468137306@qq.com")
        call append(line(".")+3, "      > Created Time: ".strftime("%c"))
        call append(line(".")+4, "      > Last changed:  TIMESTAMP")
        call append(line(".")+5, " ************************************************************************-->")
        call append(line(".")+6, "")
    endif
    if &filetype=='cpp'
        call append(line(".")+6, "#include<iostream>")
        call append(line(".")+7, "using namespace std;")
        call append(line(".")+8, "")
    endif
    if &filetype=='c'
        call setline(1, "/*************************************************************************")
        call append(line("."), "      > File Name: ".expand("%"))
        call append(line(".")+1, "      > Author: limbo")
        call append(line(".")+2, "      > Mail: 1102461126@qq.com")
        call append(line(".")+3, "      > Created Time: ".strftime("%c"))
        call append(line(".")+4, "      > Last changed: 2014年12月24日 星期三 11时12分46秒)
        call append(line(".")+5, " ************************************************************************/")
        call append(line(".")+6, "#include<stdio.h>")
        call append(line(".")+7, "")
    endif
    if &filetype=='php' || &filetype=='html'
        call setline(9,['<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">','<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">','<head>','    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />','    <title></title>','</head>','<body>','</body>','</html>'])
        endif
    if &filetype=='java'
        call setline(9,['public class '.strpart(expand("%"),0,strlen(expand("%"))-5),'{','}'])
    endif
endfunc
autocmd BufNewFile * normal G " 新建文件后，自动定位到文件末尾
