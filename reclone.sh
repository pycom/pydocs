#!/bin/bash

mkdir -p ./tmp
cd tmp
git clone git@github.com:pycom/pydocs.git
cd pydocs
git checkout gh-pages
find "." -name "*.md" -exec gcp --parents {} ../../content \;
