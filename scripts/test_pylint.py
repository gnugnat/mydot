#!/usr/bin/env python


"""
This file is part of mydot.

mydot is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3.

mydot is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with mydot.  If not, see <https://www.gnu.org/licenses/>.

Copyright (c) 2021, Maciej Barć <xgqt@riseup.net>
Licensed under the GNU GPL v3 License

Test MyDot scripts using pylint.

pylint: https://pypi.org/project/pylint/
"""


from os import walk
from os.path import exists, join
from subprocess import run


mypath = "./src"


def get_files(path: str) -> list:
    """List of all files in PATH."""
    files = []
    for (dirpath, _, filenames) in walk(path):
        for filename in filenames:
            filepath = join(dirpath, filename)
            if exists(filepath):                    # for broken symbolic links
                files.append(filepath)
    return files


def get_python_files(path: str) -> list:
    """List of all Python files in PATH."""
    files = []
    for f in get_files(path):
        topline = open(f, "r").readline()
        if "#!" in topline and "python" in topline:
            files.append(f)
    return files


def pylint_files(path: str) -> list:
    """Execute 'pylint' on files in PATH."""
    # TODO: Run asynchronously
    for f in get_python_files(path):
        print(">>> Checking file: {} ... ".format(f))
        run(["pylint", f], check=True)


def main():
    """The main function."""
    pylint_files(mypath)


if __name__ == '__main__':
    main()
