#!/bin/bash

files=( "$@" )

for file in "${files[@]}"
do
  extension=${file##*.}
  directory=$(basename -s ".$extension" "${file}")
  mkdir -p "${directory}"
  mv "${file}" "${directory}"
done
