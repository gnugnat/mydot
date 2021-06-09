# This file is part of mydot.

# mydot is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 3.

# mydot is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with mydot.  If not, see <https://www.gnu.org/licenses/>.

# Copyright (c) 2020-2021, Maciej Barć <xgqt@riseup.net>
# Licensed under the GNU GPL v3 License


.PHONY: all dependencies install uninstall test


have-%:
	@type $(@:have-%=%) >/dev/null


# 'all' placeholder

all:
	@echo "Try: install, uninstall or test"


# Install commands

dependencies:
	type stow || type xstow || type pystow || sh ./scripts/install_pystow.sh

remove-blockers:
	sh ./scripts/remove_blockers.sh

install:			dependencies
	sh ./stowdot
	@echo ">>> Install finished succesfully"

reinstall:			uninstall	install
	@echo ">>> Reinstall finished succesfully"


# Uninstall commands

remove-nvim-plugins:
	sh ./scripts/nvim_remove_plugins.sh

clean:				clean-docs	remove-nvim-plugins

uninstall:			dependencies
	sh ./stowdot remove
	@echo ">>> Uninstall finished succesfully"


# Updating mydot

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

man-eclass:
	sh ./scripts/eclass_manpages.sh

clean-docs:
	if [ -d ./docs ] ; then rm -r ./docs ; fi

docs-man:			have-help2man	have-pandoc
	sh ./scripts/manpages.sh

docs-org:			have-pandoc
	sh ./scripts/orgdocs.sh

docs:				docs-man	docs-org
	@echo ">>> Documentation build finished succesfully"


# Tests

test-elixir:		have-iex
#   does not exit with failure
	iex --dot-iex ./src/elixir/.iex.exs --eval ':c.q'

# not only used to do tests
test-emacs:			have-emacs
	sh ./scripts/emacs_reload_config.sh

test-guile:			have-guile
	mkdir -p ~/.cache/guile/ccache
	find ./src/guile -type f -exec guile {} \;

test-hyperlinks:	docs-org
	bash ./scripts/test_hyperlinks.sh

test-pylint:		have-pylint
	python ./scripts/test_pylint.py

test-racket:		have-racket
	racket --load ./src/racket/.local/share/racket/.racketrc --no-init-file

test-shellcheck:	have-shellcheck
	sh ./scripts/test_shellcheck.sh

test:	test-emacs	test-guile	test-racket	test-shellcheck
	@echo ">>> Tests finished succesfully"
