#!/usr/bin/env zsh


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

# Port of the jonathan.zsh-theme from OMZSH
# https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/jonathan.zsh-theme


_PR_FILLBAR=""
_PR_PWDLEN=""
_PR_HBAR="─"
_PR_ULCORNER="┌"
_PR_LLCORNER="└"
_PR_LRCORNER="┘"
_PR_URCORNER="┐"


theme_precmd() {
    local _termwidth
    (( _termwidth = ${COLUMNS} - 1 ))

    local _promptsize=${#${(%):---(%n@%m:%l)---()--}}
    local _pwdsize=${#${(%):-%~}}

    if [[ "${_promptsize} + ${_pwdsize}" -gt ${_termwidth} ]]
    then
        (( _PR_PWDLEN=${_termwidth} - ${_promptsize} ))
    else
        _PR_FILLBAR="\${(l.((${_termwidth} - (${_promptsize} + ${_pwdsize})))..${_PR_HBAR}.)}"
    fi
}


PROMPT='${_PR_ULCORNER}${_PR_HBAR}(%${_PR_PWDLEN}<...<%~%<<\
)${_PR_HBAR}${_PR_HBAR}${(e)_PR_FILLBAR}${_PR_HBAR}(%(!.%SROOT%s.%n)@%m:%l)${_PR_HBAR}${_PR_URCORNER}
${_PR_LLCORNER}${_PR_HBAR}(%D{%H:%M:%S})${_PR_HBAR}${vcs_info_msg_0_}${_PR_HBAR}> '

_return_code="%(?..%?)"
RPROMPT=' ${_return_code}${_PR_HBAR}(%D{%a,%b%d})${_PR_HBAR}${_PR_LRCORNER}'


zstyle ':vcs_info:git:*' formats '(%b)'

autoload -U add-zsh-hook

add-zsh-hook precmd theme_precmd
