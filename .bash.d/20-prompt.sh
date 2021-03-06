#!/bin/bash

cyan="\[$(tput setaf 6)\]"
green="\[$(tput setaf 2)\]"
bold="\[$(tput bold)\]"
reset="\[$(tput sgr0)\]"

# <username> <path/to/folder> (<branch>)
# $
PS1=${green}'\u '${cyan}'\w'
PS1+=${bold}${cyan}'$(declare -F __git_ps1 >/dev/null && __git_ps1)'
PS1+=$'\n'
PS1+=${bold}${green}'\$ '
PS1+=${reset}

unset cyan green bold reset
