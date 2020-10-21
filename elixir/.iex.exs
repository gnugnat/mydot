# Copyright (c) 2020, XGQT
# Licensed under the ISC License

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
