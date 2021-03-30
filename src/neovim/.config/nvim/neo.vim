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

" Copyright (c) 2021, Maciej Barć <xgqt@riseup.net>
" Licensed under the GNU GPL v3 License

" Initially based on:
" https://github.com/LukeSmithxyz/voidrice/blob/master/.config/nvim/init.vim


" Leader Key

let g:mapleader = "\<Space>"
let g:maplocalleader = ','

nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>


" Plugins

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
    echo "Downloading junegunn/vim-plug to manage plugins..."
    silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
    silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'ap/vim-css-color'
Plug 'colepeters/spacemacs-theme.vim'
Plug 'jreybert/vimagit'
Plug 'junegunn/goyo.vim'
Plug 'liuchengxu/vim-which-key'
Plug 'lukesmithxyz/vimling'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'vimwiki/vimwiki'
call plug#end()


" Appearance

" Spacemacs Theme
if (has("termguicolors"))
  set termguicolors
endif
set background=dark
colorscheme spacemacs-theme


" Misc Plugins

" NerdTree
let NERDTreeShowHidden=1
