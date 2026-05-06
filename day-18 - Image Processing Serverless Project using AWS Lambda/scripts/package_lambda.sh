#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/build"

echo "Cleaning build folder..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/python"

echo "Packaging Lambda function..."
powershell.exe -NoProfile -Command "Compress-Archive -Path '$(cygpath -w "$ROOT_DIR/lambda/lambda_function.py")' -DestinationPath '$(cygpath -w "$BUILD_DIR/lambda_function.zip")' -Force"

echo "Installing Pillow for AWS Lambda Linux runtime..."
python -m pip install \
  pillow==10.4.0 \
  --platform manylinux2014_x86_64 \
  --implementation cp \
  --python-version 3.11 \
  --only-binary=:all: \
  -t "$BUILD_DIR/python"

echo "Packaging Pillow Lambda layer..."
powershell.exe -NoProfile -Command "Compress-Archive -Path '$(cygpath -w "$BUILD_DIR/python")' -DestinationPath '$(cygpath -w "$BUILD_DIR/pillow_layer.zip")' -Force"

echo "Package completed."
echo "Lambda zip: $BUILD_DIR/lambda_function.zip"
echo "Layer zip: $BUILD_DIR/pillow_layer.zip"