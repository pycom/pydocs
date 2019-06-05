# local visualization

.md files are in the content folder, the theme forlder contains the theme.

install Hugo and run it on the current directory.
```
brew install hugo
hugo serve
```

The file config.toml contains the global .toml

# First generation of publish branch

Some commands that have been used for building:

- ```
# it clone gh-pages in ./tmp/ and appy all .md files
./reclone.sh
# generate toc, title, redirects
python3 migration.py
# apply this changes to remove remaining not needed slashes protections
rpl -R '\)' ')' *
rpl -R '\(' '(' *
#  use carrefully but there should be not .html in content
# find "./content/" -name "*.html" -exec rm {} \;
#  then finally fix link self to images
rpl -R ".gitbook/assets/" "gitbook/assets/" *
rpl -R "../gitbook/assets" "/gitbook/assets" content
rpl -R "..//gitbook/assets" "/gitbook/assets" content
rpl -R "’" "'" content
# get the images in static
cp tmp/pydocs/.gitbook/assets/* static/gitbook/assets/
```
