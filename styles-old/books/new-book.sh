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
echo "Building template for $1 under theme $2."
working_dir="$(pwd)"
cd "${0%/*}"
book_template_name="__book-template__"
cp -r $book_template_name $1
cd $1
for file_or_dir in $(find . -name "*__book-template__*"); do
  mv "$file_or_dir" "${file_or_dir/__book-template__/$1}"
done
if grep -rl "__book-template__" . | xargs sed -i '' "s/__book-template__/$1/g" >/dev/null 2>&1; then
  echo "OSX sed succeeded."
else
  echo "OSX sed failed. Trying GNU sed."
  grep -rl "__book-template__" . | xargs sed -i "s/__book-template__/$1/g"
fi
if grep -rl "__template-theme__" . | xargs sed -i '' "s/__template-theme__/$2/g" >/dev/null 2>&1; then
  echo "OSX sed succeeded."
else
  echo "OSX sed failed. Trying GNU sed."
  grep -rl "__template-theme__" . | xargs sed -i "s/__template-theme__/$2/g"
fi
cd $pwd
echo "Done."
