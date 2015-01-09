#!/bin/bash

# Fast fail the script on failures.
set -e

# Start a virtual frame buffer.
if [ "$DRONE" = "true" ]; then
  sudo start xvfb
fi

# Display installed versions.
dart --version

# Get our packages.
pub get

# Verify that the libraries are error free.
dartanalyzer --fatal-warnings \
  lib/html.dart \
  lib/io.dart \
  test/html_test.dart \
  test/io_test.dart

# Test the dart:io version.
dart test/io_test.dart

# TODO: Test the dart:html version.
