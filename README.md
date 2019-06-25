# run locally

```
brew install hugo
hugo serve
```

# Workflow

- make you clean commits on Master
- Then merge publish with master


# some infos:

- assets are in ./static directory, a directory aliased at /
- css in /themes/doc-theme/static/doc-theme.css
- SUMMARY.md is in config.toml


# help

- gohugo.io


# detect broken links

```
wget -o 404.txt -r  --spider http://localhost:1313
```

A webhook has been installed on the publish branch to
https://publish.d20i0wkqbblkur.amplifyapp.com/

## First generation of publish branch (in memoriam)

Some commands that have been used for building:

```bash
# it clone gh-pages in ./tmp/ and appy all .md files
./reclone.sh
# generate toc, title, redirects
python3 migration.py
# apply this changes to remove remaining not needed slashes protections
rpl -R '\)' ')' content/*
rpl -R '\(' '(' content/*
#  use carrefully but there should be not .html in content
# find "./content/" -name "*.html" -exec rm {} \;
#  then finally fix link self to images
rpl -R ".gitbook/assets/" "gitbook/assets/" *
rpl -R "../gitbook/assets" "/gitbook/assets" content
rpl -R "..//gitbook/assets" "/gitbook/assets" content
rpl -R "’" "'" content
rpl -R "✔" "&#10004;" content
rpl -R "{{{%" "{{%" content
rpl -R "%}}}" "%}}" content


# get the images in static
cp -R tmp/pydocs/.gitbook/assets/* static/gitbook/assets/
```
