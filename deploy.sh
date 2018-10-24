#!/usr/bin/env bash

# do not continue if pull request
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "This is a PR, exiting..."
  exit 0
fi

# enable error reporting to the console
set -e

# build
mkdocs build --clean --theme-dir ./theme/ --site-dir ./out/
build_result=$?
if [ "$build_result" == "0" ]; then
  cd ./out/
  git init
  git config user.name "librenms-docs"
  git config user.email "travis@librenms.org"
  git add .
  git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
  git push --force --quiet "git@${GH_REF}" master:master
else
  exit ${build_result}
fi
