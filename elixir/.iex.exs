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

# Copyright (c) 2020, XGQT
# Licensed under the GNU GPL v3 License

# Based upon:
#  https://github.com/blackode/custom-iex


# Additional environment settings

# Import ecto quries for testing quries in iex
import_if_available(Ecto.Query)

# Enable ANSI
Application.put_env(:elixir, :ansi_enabled, true)

# Color
magenta_ansi = IO.ANSI.magenta()
reset_ansi = IO.ANSI.reset()


# Prompt

IEx.configure(
  colors: [enabled: true],
  # This will display when we enter multiple lines of code
  continuation_prompt: magenta_ansi <> "... " <> reset_ansi,
  default_prompt:
  [
    # ANSI CHA, move cursor to column 1
    "\e[G",
    :yellow,
    #"%prefix",
    #"(%counter)",
    :magenta,
    # UTF "❯" symbol
    "\u276f\u276f\u276f",
    :reset
  ]
  |> IO.ANSI.format()
  |> IO.chardata_to_string()
)


# Greeter

greeting_text = magenta_ansi <>
  "\n" <>
  "        .:        \n" <>
  "      .::.        \n" <>
  "    .lllc:.       \n" <>
  "   .xo::::l.      \n" <>
  "  .O'.''.looc.    \n" <>
  "  .c..::.oxx.:.   \n" <>
  " ..'...'.dkkc..'  \n" <>
  " '''....lOOOd'''. \n" <>
  " ......k0000k.... \n" <>
  "  coloKXXXXKc:cc. \n" <>
  "   'lkNNNNKd...   \n" <>
  "     ':xxll:'     \n" <>
  reset_ansi

IO.puts(greeting_text)
