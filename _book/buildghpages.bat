
gitbook install --gitbook=3.2.3 
gitbook build --gitbook=3.2.3
git checkout gh-pages
git pull origin gh-pages --rebase
cp -R _book/* .
git clean -fx node_modules
git clean -fx _book
git add .
git commit -a -m "Update docs"
git push origin gh-pages
git checkout master