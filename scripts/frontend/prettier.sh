#!/usr/bin/env bash
set -o noglob

: ${1?"Usage: $0 <check|save|check-all|save-all>"}

PRETTIER_PATH=$(git rev-parse --show-toplevel)/node_modules/.bin/prettier

if [ ! -f $PRETTIER_PATH ]; then
    echo "ERROR: Prettier not found!"
    exit 1
fi

case $1 in
check)
  action=check
  prettier_args=--list-different
  files=staged
  ;;
save)
  action=save
  prettier_args=--write
  files=staged
  ;;
check-all)
  action=check
  prettier_args=--list-different
  files=all
  ;;
save-all)
  action=save
  prettier_args=--write
  files=all
  ;;
*)
  echo "$1 is not a valid argument, please use check, save, check-all or save-all"
  exit 1
  ;;
esac

echo -e "Loading $files files ...\n"

if [ "$files" == "staged" ]; then
    file_list=$(git diff --name-only --cached --diff-filter=ACMRTUB '*.vue' '*.js' '*.scss'  | tr '\r\n' ' ')
else
    file_list="**/*.vue **/*.js **/*.scss"
fi

if [ "$action" == "check" ]; then
    if $PRETTIER_PATH $prettier_args $file_list; then
        echo -e "\nFormat of $files files is correct."
        exit 0
    else
        echo -e "\n===============================\nGitLab uses Prettier to format all JavaScript code.\nPlease format each file listed below or run 'yarn prettier-$files-save'\n===============================\n"
        exit 1
    fi
fi

if [ "$action" == "save" ]; then
    if $PRETTIER_PATH $prettier_args $file_list; then
        echo -e "\nFormatted $files files successfully with prettier."
        exit 0
    else
        echo -e "\nSomething went wrong while formatting with prettier."
        exit 1
    fi
fi

echo "ERROR: Something went wrong"

exit 1
