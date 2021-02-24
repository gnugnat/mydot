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
	@echo Try: install, uninstall or test


# Install commands

dependencies:
	sh -c "command -v stow || command -v xstow || command -v pystow || sh ./install_pystow.sh"

install:	dependencies
	sh ./stowdot


# Uninstall commands

uninstall:
	sh ./stowdot remove


# Updating mydot

git-reset:
	git reset --hard

git-pull:
	git pull

git-modules:
	git submodule update --init

git-update:	git-reset	git-pull	git-modules

update-mydot:	uninstall	git-update	install


# Tests

test-emacs:
	sh ./emacs/.config/emacs/load.sh --batch

test-guile:
	mkdir -p ~/.cache/guile/ccache
	find ./guile -type f -exec guile {} \;

test-racket:
	racket --load ./racket/.local/share/racket/.racketrc --no-init-file

test-shellcheck:
	sh ./shellcheck.sh

test:	test-emacs	test-guile	test-racket	test-shellcheck
