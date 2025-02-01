#!/bin/bash

BZL_FILE="../libc++.bzl"

echo "LIBCXX_OUTS = [" > $BZL_FILE
files=$(tar -cvJf libc++.tar.xz * | grep -v '/$')

for file in $files; do
  echo "processing $file"
  echo "  \"$file\"," >> $BZL_FILE
done
echo "]" >> $BZL_FILE
