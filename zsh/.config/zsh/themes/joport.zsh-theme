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

# Copyright (c) 2020, XGQT
# Licensed under the GNU GPL v3 License

# Port of the jonathan.zsh-theme from OMZSH
# https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/jonathan.zsh-theme


theme_precmd() {
    local TERMWIDTH
    (( TERMWIDTH = ${COLUMNS} - 1 ))

    PR_FILLBAR=""
    PR_PWDLEN=""

    local promptsize=${#${(%):---(%n@%m:%l)---()--}}
    local pwdsize=${#${(%):-%~}}

    if [[ "${promptsize} + ${pwdsize}" -gt ${TERMWIDTH} ]]
    then
        (( PR_PWDLEN=${TERMWIDTH} - ${promptsize} ))
    else
        PR_FILLBAR="\${(l.((${TERMWIDTH} - (${promptsize} + ${pwdsize})))..${PR_HBAR}.)}"
    fi

}


pre_git_check="("
post_git_check=")"

PR_HBAR="─"
PR_ULCORNER="┌"
PR_LLCORNER="└"
PR_LRCORNER="┘"
PR_URCORNER="┐"

PROMPT='${PR_ULCORNER}${PR_HBAR}(%${PR_PWDLEN}<...<%~%<<\
)${PR_HBAR}${PR_HBAR}${(e)PR_FILLBAR}${PR_HBAR}(%(!.%SROOT%s.%n)@%m:%l)${PR_HBAR}${PR_URCORNER}
${PR_LLCORNER}${PR_HBAR}(%D{%H:%M:%S})${PR_HBAR}$(git_check)${PR_HBAR}> '

return_code="%(?..%?)"
RPROMPT=' ${return_code}${PR_HBAR}(%D{%a,%b%d})${PR_HBAR}${PR_LRCORNER}'


autoload -U add-zsh-hook

add-zsh-hook precmd  theme_precmd
