#!/bin/bash
if [[ -z "$1" ]]; then
  echo "No book name given. Aborting."
  exit 1
fi
if [[ -z "$2" ]]; then
  echo "No theme name given. Aborting."
  exit 1
fi
if [[ -d $1 || -f $1 ]]; then
  echo "Files for $1 already exist. Aborting."
  exit 1
fi
echo "Generating template for $1 under theme $2."
working_dir="$(pwd)"
cd "${0%/*}"
book_template_name="__book-template__"
cp -r $book_template_name $1
cd $1
rename "s/__book-template__/$1/" ./*
grep -rl "__book-template__" . | xargs sed -i "s/__book-template__/$1/g"
grep -rl "__template-theme__" . | xargs sed -i "s/__template-theme__/$2/g"
cd $pwd
echo "Done."
