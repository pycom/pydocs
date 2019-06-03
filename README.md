notes:

Some commands that have been used for building

- ```
python3 migration.py
rpl -R '\)' ')' *
rpl -R '\(' '(' *
find "./content/" -name "*.html" -exec rm {} \;
rpl -R ".gitbook/assets/" "gitbook/assets/" *
rpl -R "../gitbook/assets" "/gitbook/assets" content
```

- ```

rpl -R '\(' '(' *

```

TODO:
- redirects
- [Libraries GitHub repository](https://github.com/pycom/pycom-libraries)
- next page
- google as ajax
