#!/usr/bin/env bash

echo 'pub get'
pub get || exit $?
echo 'pub run dart_dev coverage --pub-serve --no-open'
pub run dart_dev coverage || exit $?
