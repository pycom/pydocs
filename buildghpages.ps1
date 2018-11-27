gitbook install --gitbook=3.2.3
gitbook build --gitbook=3.2.3

cp _book/chapter/pybytes.html _book/chapter/pybytes/index.html
cp _book/chapter/pybytes.html _book/pybytes.html
cp _book/chapter/pybytes.html _book/pybytes/index.html

cp -R _book/* .

git clean -fx node_modules
git clean -fx _book
