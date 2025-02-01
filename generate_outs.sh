#!/bin/bash

DEB_FILE=$1
REMOVE_SO=${2:-false}

IFS='_' read -r -a parts <<< "$DEB_FILE"
NAME=${parts[0]}
VAR_NAME=${NAME//-/_}
VAR_NAME=${VAR_NAME//+/x}
VAR_NAME=${VAR_NAME^^}
BZL_FILE="$(pwd)/${NAME}.bzl"

mkdir -p staging
cp $DEB_FILE staging

pushd staging

echo "${VAR_NAME}_OUTS = [" > $BZL_FILE
files=$(dpkg-deb -v -x $DEB_FILE . | grep -v '/$')

if [ "$REMOVE_SO" = true ]; then
    files=$(echo "$files" | grep -v '\.so$')
fi

for file in $files; do
  file=${file:2}
  echo "  \"$file\"," >> $BZL_FILE
done
echo "]" >> $BZL_FILE

popd

rm -rf staging