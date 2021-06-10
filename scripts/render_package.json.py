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
"""


import argparse

from sys import exit as EXIT

from jinja2 import Template
from semantic_version import validate


def render_package_json(version: str):
    """Render package.json"""

    with open("./package.json.j2", "r") as templete_file:
        template = Template(templete_file.read()).render(version=version)

    with open("./package.json", "w") as output_file:
        output_file.write(template)


def main():
    """The main function."""

    parser = argparse.ArgumentParser(
        description="%(prog)s - generate package.json from package.json.j2",
        epilog='''Copyright (c) 2021, Maciej Barć <xgqt@riseup.net>
    Licensed under the GNU GPL v3 License'''
    )
    parser.add_argument(
        "version",
        type=str,
        help="version string to use, following 'semver', ie.: 9.9.9"
    )
    args = parser.parse_args()
    v = args.version

    if validate(v):
        render_package_json(v)
    else:
        print("[ERROR]: Given version sting {} is incorrect.".format(v))
        print("         Please follow the semver specification.")
        EXIT(1)


if __name__ == '__main__':
    main()
