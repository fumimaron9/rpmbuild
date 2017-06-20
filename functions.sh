#!/bin/bash

# from: https://github.com/direnv/direnv/blob/3bb35d375331fca89614f0015b2a6cd21688ab79/bin/direnv
# usage: abs_dirname $filename
abs_dirname() {
  prev_path="$1"
  # Resolve the symlink(s) recursively
  while true; do
    abs_path=`readlink "$prev_path"`
    if [ -z "$abs_path" ]; then
      abs_path="$prev_path"
      break
    else
      prev_path="$abs_path"
    fi
  done
  unset prev_path

  # Get the absolute directory of the final $abs_path
  orig_dir=`pwd`
  cd `dirname "$abs_path"`
  # prints an absolute path here
  pwd
  cd "$orig_dir"
  unset abs_path orig_dir
}

# from: http://qiita.com/tkhren/items/d86b8ae6c1a67da0aa67
tco() {  # {{{ 
    ## echo $(tco RED)Hello$(tco)
    ## echo $(tco RED Hello)
    ## PS1="$(tco -e RED \u@\h)"

    local output=
    local i=0 c= opt_e=
    local colors=(black red green yellow blue magenta cyan white \
                  BLACK RED GREEN YELLOW BLUE MAGENTA CYAN WHITE)  # Bolded

    [[ $1 = "-e" ]] && opt_e=1 && shift

    for c in ${colors[@]}; do
        if [[ $1 == $c ]]; then
            [[ $i -gt 7 ]] && output+="\[$(tput bold)\]"
            output+="\[$(tput setaf $((i % 8)))\]"
            shift
            break
        fi
        ((i++))
    done
    if [[ ( $# -ne 0 ) || ( $i -eq ${#colors[@]} ) ]]; then
        output+="$@\[$(tput sgr0)\]"
    fi
    if [[ -z $opt_e ]]; then
        output="$(echo "$output" | sed -E 's/\\\[|\\\]//g')"
    fi
    echo -n "$output"
}  # }}}

function yes_or_no() {
  local MESSAGE="";
  local ANSWER="";

  MESSAGE="$1 (yes/no)? ";
  if [ "$1" = "1" ]; then
    MESSAGE="Please retype (yes/no)? ";
  fi

  read -p "${MESSAGE}" ANSWER;

  case $ANSWER in
    yes)
      return 0;
      ;;
    no)
      echo "Stopped script.";
      return 1;
      ;;
    *)
      yes_or_no "1";
      ;;
  esac
}

# same
#readonly SCRIPT_PATH=$(readlink -f $0)
#readonly SCRIPT_DIR=$(dirname ${SCRIPT_PATH})
#readonly SCRIPT_NAME=$(basename $SCRIPT_PATH) # SCRIPT_FILE
# memo REALPATH=$(cd $SCRIPT_DIR/../; pwd)
readonly SCRIPT_DIR="$(abs_dirname)";
readonly SCRIPT_FILE="$(basename ${0})";

