# Start a virtual frame buffer.
if [ "$DRONE" = "true" ]; then
  sudo start xvfb
fi

# Display installed versions.
dart --version

# Get our packages.
pub get

# Test the dart:io version.
dart test/io_test.dart

# TODO: Test the dart:html version.
