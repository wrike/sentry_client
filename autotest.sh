#!/usr/bin/env bash

echo 'pub get'
pub get || exit $?
echo 'pub run dart_dev analyze'
pub run dart_dev analyze || exit $?
echo 'pub run dart_dev test'
pub run dart_dev test || exit $?
