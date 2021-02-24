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


# 'all' placeholder

all:
	@echo "Try: install, uninstall or test"


# Install commands

dependencies:
	sh -c "command -v stow || command -v xstow || command -v pystow || sh ./install_pystow.sh"

install:	dependencies
	sh ./stowdot


# Uninstall commands

uninstall:	dependencies
	sh ./stowdot remove


# Updating mydot

have-git:
	@command -v git >/dev/null

git-reset:	have-git
	git reset --hard

git-pull:	have-git
	git pull

git-modules:	have-git
	git submodule update --init

git-update:	git-reset	git-pull	git-modules

update-mydot:	have-git	uninstall	git-update	install


# Tests

have-emacs:
	@command -v emacs >/dev/null

have-guile:
	@command -v guile >/dev/null

have-racket:
	@command -v racket >/dev/null

have-shellcheck:
	@command -v shellcheck >/dev/null

test-emacs:	have-emacs
	sh ./emacs/.config/emacs/load.sh --batch

test-guile:	have-guile
	mkdir -p ~/.cache/guile/ccache
	find ./guile -type f -exec guile {} \;

test-racket:	have-racket
	racket --load ./racket/.local/share/racket/.racketrc --no-init-file

test-shellcheck:	have-shellcheck
	sh ./shellcheck.sh

test:	test-emacs	test-guile	test-racket	test-shellcheck
	@echo ">>> Tests finished succesfully"
