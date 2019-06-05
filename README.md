#

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

TODO:
- prev. page,next page
- google as ajax


User name,Password,Access key ID,Secret access key,Console login link
amplify-user,,AKIA33VTBXYKK6EXAZ6X,u7bKI47L1jCyAKyPn/4rps2Sj3vnKt/j/+BIajaM,https://pycom-prod.signin.aws.amazon.com/console
