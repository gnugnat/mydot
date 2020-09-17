.PHONY: all install uninstall test


all:
	@echo Try: install, uninstall or test


install:
	bash ./stowdot


uninstall:
	bash ./stowdot remove


test:
	bash ./test.sh
