#!/bin/sh

function add_file_to_project() {
  local FILE_NAME=
  local TXT=
  local file=
  local path=
  if [ -n "${2}" ]; then
    FILE_NAME="${2}"
  fi
  if [ -n "${3}" ]; then
    TXT="${3}"
  fi
  EDITORCONFIG_TXT_FOR_PROJECTS=$(ls -F "${1}" | grep "/$")
  #echo "${1},$EDITORCONFIG_TXT_FOR_PROJECTS"
  REG_SHELL_COMMOMENT_PATTERN="^#"
  EDITORCONFIG_TXT_FOR_PROJECTS_ARR=(${EDITORCONFIG_TXT_FOR_PROJECTS//,/ })
  for var in ${EDITORCONFIG_TXT_FOR_PROJECTS_ARR[@]}; do

    if [[ "$var" =~ $REG_SHELL_COMMOMENT_PATTERN ]]; then
      echo "$var" >/dev/null 2>&1
    else
      #cp --force .editorconfig "${1}$var$FILE_NAME"
      file="${1}/$var$FILE_NAME"
      path="${1}/$var"
      #echo "$file"

      if test -d $path; then
        cd "$path"
        #temp=$(pwd)
        #echo "it is dir:$path,now is in $temp"
        #rm -rf "$FILE_NAME"
        if [ -e "$FILE_NAME" ]; then
          echo "file exists --$file" >/dev/null 2>&1
        else
          echo "file does not exists--$file"
          echo "$TXT" >"$file"
          #echo "$FILE_NAME"
          git add "$FILE_NAME"
          git_commit_init "$FILE_NAME"
        fi
      fi
    fi
  done
}
###
# fun-usage
# add_file_to_project "../" ".editorconfig" "$GITIGNORE_TXT"

function init_file_to_project() {
  local FILE_NAME=
  local TXT=
  local file=
  local path=
  if [ -n "${2}" ]; then
    FILE_NAME="${2}"
  fi
  if [ -n "${3}" ]; then
    TXT="${3}"
  fi
  EDITORCONFIG_TXT_FOR_PROJECTS=$(ls -F "${1}" | grep "/$")
  #echo "${1},$EDITORCONFIG_TXT_FOR_PROJECTS"
  REG_SHELL_COMMOMENT_PATTERN="^#"
  EDITORCONFIG_TXT_FOR_PROJECTS_ARR=(${EDITORCONFIG_TXT_FOR_PROJECTS//,/ })
  for var in ${EDITORCONFIG_TXT_FOR_PROJECTS_ARR[@]}; do

    if [[ "$var" =~ $REG_SHELL_COMMOMENT_PATTERN ]]; then
      echo "$var" >/dev/null 2>&1
    else
      #cp --force .editorconfig "${1}$var$FILE_NAME"
      file="${1}/$var$FILE_NAME"
      path="${1}/$var"
      #echo "$file"

      if test -d $path; then
        cd "$path"
        #temp=$(pwd)
        #echo "it is dir:$path,now is in $temp"
        #rm -rf "$FILE_NAME"
        if [ -e "$FILE_NAME" ]; then
          echo "$FILE_NAME"
          git add "$FILE_NAME"
          git_init_readme
        fi
      fi
    fi
  done
}

function git_init_a_dir() {
  local file_list=
  local file=
  local path=
  local temp=
  file_list=$(ls "${1}")
  #echo $file_list
  for file in $file_list; do
    #echo "${1}/${file}"
    path="${1}/${file}"
    if test -d $path; then
      #run task for dir
      #echo "dir:$file"
      cd "${1}/${file}"
      git status >/dev/null 2>&1
      if [ $? -eq 0 ]; then
        echo "git repo exitst in path :${1}/${file}" >/dev/null 2>&1
      else
        #echo "git repo  does not exists in path :${1}/${file}"
        git init
      fi
    else
      echo "it is file :$path" >/dev/null 2>&1
    fi
  done
}

function path_resolve_for_relative() {
  local str1="${1}"
  local str2="${2}"
  local slpit_char1=/
  local slpit_char2=/
  if [[ -n ${3} ]]; then
    slpit_char1=${3}
  fi
  if [[ -n ${4} ]]; then
    slpit_char2=${4}
  fi

  # 路径-转为数组
  local arr1=(${str1//$slpit_char1/ })
  local arr2=(${str2//$slpit_char2/ })

  # 路径-解析拼接
  #2 遍历某一数组
  #2 删除元素取值
  #2 获取数组长度
  #2 获取数组下标
  #2 数组元素赋值
  for val2 in ${arr2[@]}; do
    length=${#arr1[@]}
    if [ $val2 = ".." ]; then
      index=$(($length - 1))
      if [ $index -le 0 ]; then index=0; fi
      unset arr1[$index]
      #echo ${arr1[*]}
      #echo  $index
    elif [ $val2 = "." ]; then
      echo "current path" >/dev/null 2>&1
    else
      index=$length
      arr1[$index]=$val2
      #echo ${arr1[*]}
    fi
  done
  # 路径-转为字符
  local str3=''
  for i in ${arr1[@]}; do
    str3=$str3/$i
  done
  if [ -z $str3 ]; then str3="/"; fi
  echo $str3
}
function path_resolve() {
  local str1="${1}"
  local str2="${2}"
  local slpit_char1=/
  local slpit_char2=/
  if [[ -n ${3} ]]; then
    slpit_char1=${3}
  fi
  if [[ -n ${4} ]]; then
    slpit_char2=${4}
  fi

  #FIX:when passed asboult path,dose not return the asboult path itself
  #str2="/d/"
  local str3=""
  str2=$(echo $str2 | sed "s#/\$##")
  ABSOLUTE_PATH_REG_PATTERN="^/"
  if [[ $str2 =~ $ABSOLUTE_PATH_REG_PATTERN ]]; then
    str3=$str2
  else
    str3=$(path_resolve_for_relative $str1 $str2 $slpit_char1 $slpit_char2)
  fi
  echo $str3
}

function git_init_editorconfig() {
  COMMIT_MSG=$(
    cat <<EOF
style(editorconfig): initing a .editorconfig file
EOF
  )
  echo "$COMMIT_MSG" >.git/COMMIT_EDITMSG
  git commit --file .git/COMMIT_EDITMSG
}

function git_init_gitignore() {
  COMMIT_MSG=$(
    cat <<EOF
build(git): initing a .gitignore file
EOF
  )
  echo "$COMMIT_MSG" >.git/COMMIT_EDITMSG
  git commit --file .git/COMMIT_EDITMSG
}
function git_init_license() {
  COMMIT_MSG=$(
    cat <<EOF
build(license): initing a license file
EOF
  )
  echo "$COMMIT_MSG" >.git/COMMIT_EDITMSG
  git commit --file .git/COMMIT_EDITMSG
}
function git_init_readme() {
  COMMIT_MSG=$(
    cat <<EOF
docs(basic): initing a readme file
EOF
  )
  echo "$COMMIT_MSG" >.git/COMMIT_EDITMSG
  git commit --file .git/COMMIT_EDITMSG
}

function git_commit_init() {
  local file=
  if [ -n "${1}" ]; then
    file="${1}"
  fi
  if [ $file = ".editorconfig" ]; then
    git_init_editorconfig
  elif [ $file = ".gitignore" ]; then
    git_init_gitignore
  elif [ $file = "license" ]; then
    git_init_license
  fi
}
