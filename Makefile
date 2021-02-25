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
	type stow || type xstow || type pystow || sh ./.helpers/install_pystow.sh

clean:				git-update
	sh ./.helpers/remove_blockers.sh

install:			dependencies
	sh ./stowdot
	@echo ">>> Install finished succesfully"


# Uninstall commands

uninstall:			dependencies
	sh ./stowdot remove
	@echo ">>> Uninstall finished succesfully"


# Updating mydot

have-git:
	@type git >/dev/null

git-reset:			have-git
	git reset --hard

git-pull:			have-git
	git pull

git-modules:		have-git
	git submodule update --init

git-update:			git-reset	git-pull	git-modules

update-mydot:		have-git	uninstall	git-update	install
	@echo ">>> Update finished succesfully"


# Documentation

have-help2man:
	@type help2man >/dev/null

have-pandoc:
	@type pandoc >/dev/null

man:				have-help2man	have-pandoc
	sh ./.helpers/manpages.sh

docs:				man


# Tests

have-emacs:
	@type emacs >/dev/null

have-guile:
	@type guile >/dev/null

have-racket:
	@type racket >/dev/null

have-shellcheck:
	@type shellcheck >/dev/null

test-emacs:			have-emacs
	sh ./emacs/.config/emacs/load.sh --batch

test-guile:			have-guile
	mkdir -p ~/.cache/guile/ccache
	find ./guile -type f -exec guile {} \;

test-racket:		have-racket
	racket --load ./racket/.local/share/racket/.racketrc --no-init-file

test-shellcheck:	have-shellcheck
	sh ./.helpers/shellcheck.sh

test:	test-emacs	test-guile	test-racket	test-shellcheck
	@echo ">>> Tests finished succesfully"
