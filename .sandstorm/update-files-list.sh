#!/bin/bash

#go to root project directory
cd "$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"
cd ..

#Make sure all php files are included
exts=( "php" )
for ext in "${exts[@]}"
do
    find $PWD -type f -name "*.${ext}" \
    -not -path "*/test/*" \
    -not -path "*/Test/*" \
    -not -path "*/tests/*" \
    -not -path "*/Tests/*" \
    -not -path "*/testing/*" \
    -not -path "*/Testing/*" \
    -not -path "*/unitTests/*" \
    | sed -e "s|^$PWD|opt/app|g" >> $PWD/.sandstorm/sandstorm-files.list
done

#Make sure all assets are included
exts=( "css" "js" "png"  "jpg" "ico" "svg" "ttf" "woff" "woff2" "eot" )
for ext in "${exts[@]}"
do
    find $PWD/public -type f -name "*.${ext}" | sed -e "s|^$PWD|opt/app|g" >> $PWD/.sandstorm/sandstorm-files.list
done
