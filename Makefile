# Copyright (c) 2020, XGQT
# Licensed under the ISC License


.PHONY: all install uninstall test


all:
	@echo Try: install, uninstall or test


install:
	bash ./stowdot


uninstall:
	bash ./stowdot remove


test:
	bash ./test.sh
