# This file is part of mydot.

# mydot is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# mydot is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with mydot.  If not, see <https://www.gnu.org/licenses/>.

# Copyright (c) 2020-2021, Maciej Barć <xgqt@protonmail.com>
# Licensed under the GNU GPL v3 License


.PHONY: all dependencies install uninstall test


all:
	@echo Try: install, uninstall or test


dependencies:
	sh -c "command -v stow || command -v xstow || command -v pyystow || sh ./install_pystow.sh"

install:	dependencies
	sh ./stowdot


uninstall:
	sh ./stowdot remove


test-emacs:
	mkdir -p ~/.config/emacs
	mkdir -p ~/Documents
	touch ~/Documents/todo.org
	cd ./emacs/.config/emacs && emacs --batch --no-init --load ./init.el

test-guile:
	mkdir -p ~/.cache/guile/ccache
	find ./guile -type f -exec guile {} \;

test-racket:
	racket --load ./racket/.local/share/racket/.racketrc --no-init-file

test-shellcheck:
	sh ./shellcheck.sh

test:	test-emacs	test-guile	test-racket	test-shellcheck
