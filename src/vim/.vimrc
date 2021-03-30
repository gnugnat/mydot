" This file is part of mydot.

" mydot is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, version 3.

" mydot is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.

" You should have received a copy of the GNU General Public License
" along with mydot.  If not, see <https://www.gnu.org/licenses/>.

" Copyright (c) 2020-2021, Maciej Barć <xgqt@riseup.net>
" Licensed under the GNU GPL v3 License

"        _
" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|
"


" encoding
set encoding=utf-8

" numbers
set number relativenumber

" position number, document label
set ruler

" syntax color
syntax on

" autocompletion
set wildmode=longest,list,full

" dark background
set background=dark

" auto indenting
set autoindent

" search highlighting
set hlsearch

" incremental search
set incsearch

" copy to system clipboard
set clipboard=unnamedplus

" show tabs as dots
set list
set listchars=tab:..

" custom bindings
nmap q :q<CR>

" Neovim specific commands
if has('nvim')
    source $HOME/.config/nvim/neo.vim
endif
