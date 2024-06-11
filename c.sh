#!/usr/bin/sh

VERSION="0.0.1"

GCC_WARNINGS=(
    "-Wall"
    "-Wextra"
    "-Werror=format-security"
    "-Werror=implicit-function-declaration"
    "-D_FORTIFY_SOURCE=2"
    "-O2"
)

STANDAR="c23"

path=$(pwd)
name=""

_build() {
    for ((i=${#file}; 0 <= i; i-=1)) do
        if [[ ${file:$i:1} == "." ]]; then
            name=${file::$i}
        fi
    done
    if [[ name == "" ]]; then
        echo "ERROR: No name found"
        exit
    fi
    gcc ${GCC_WARNINGS[@]} -std=$STANDAR "$path/$file" -o "$name" $2
}

_help() {
    echo "Usage: c [COMMAND] [FILE] [\"GCC_COMMANDS\"]"
    echo ""
    echo "Commands:"
    echo ""
    echo "    build    compile a file with gcc"
    echo "    brun     compile and then run the executable"
    echo "    run      compule and run the executable, and remove it"
    echo "    options  show all the options that are set to gcc"
    echo "    help     this text"
    echo ""
}

case "$1" in
    "build")
        if [[ ! "$2" ]]; then
            _help
        else
            _build "$2" "$3" "$4" "$5"
        fi
        ;;
    "brun")
        if [[ ! "$2" ]]; then
            _help
        else
            _build "$2" "$3" "$4" "$5"
            x=$("$path/$name")
        fi
        ;;
    "run")
        if [[ ! "$2" ]]; then
            _help
        else
            _build "$2" "$3"
            x=$("$path/$name")
            rm "$path/$name"
        fi
        ;;
    "options")
        echo "Warnings and Security:"
        for w in ${GCC_WARNINGS[@]}; do
            echo "  $w"
        done
        echo ""
        echo "Standar: $STANDAR"
        ;;
    *) _help ;;
esac
