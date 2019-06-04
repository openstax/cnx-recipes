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
book_template_name="intro-business"
cp -r $book_template_name $1
cd $1
for file_or_dir in $(find . -name "*intro-business*"); do
  mv "$file_or_dir" "${file_or_dir/intro-business/$1}"
done
if grep -rl "intro-business" . | xargs sed -i '' "s/intro-business/$1/g" >/dev/null 2>&1; then
  echo "OSX sed succeeded."
else
  echo "OSX sed failed. Trying GNU sed."
  grep -rl "intro-business" . | xargs sed -i "s/intro-business/$1/g"
fi
if grep -rl "theme3" . | xargs sed -i '' "s/theme3/$2/g" >/dev/null 2>&1; then
  echo "OSX sed succeeded."
else
  echo "OSX sed failed. Trying GNU sed."
  grep -rl "theme3" . | xargs sed -i "s/theme3/$2/g"
fi
cd $pwd
echo "Done."
