#!/bin/bash

# MUST BE RUN ON LINUX TO BUILD CORRECTLY
# Only builds for node version used on x64

node_version="v$(node -p 'process.versions.modules')"

binding_dir="src/binding"

win32_url="https://github.com/tessel/node-usb/releases/download/1.5.0/usb_bindings-v1.5.0-node-$node_version-win32-x64.tar.gz"
darwin_url="https://github.com/tessel/node-usb/releases/download/1.5.0/usb_bindings-v1.5.0-node-$node_version-darwin-x64.tar.gz"

win32_file_name="usb_bindings_win32_$node_version.node"
darwin_file_name="usb_bindings_darwin_$node_version.node"
linux_file_name="usb_bindings_linux_$node_version.node"


if [[ -z $(ls libusb) ]]; then
  echo '> please initialize and update git submodules'
  exit 1
fi

if ! [[ -d "$binding_dir" ]]; then
  echo "> binding dir not found, creating '$binding_dir'"
  mkdir -p "$binding_dir"
fi

rm -f "$binding_dir/usb_bindings.node"

set -e

npm install && rm -f package-lock.json

echo "> fetching $darwin_file_name from tessel/usb@1.5.0..."
curl -sL -o "$binding_dir/$darwin_file_name" "$darwin_url"
echo "> done"

echo "> fetching $win32_file_name from tessel/usb@1.5.0..."
curl -sL -o "$binding_dir/$win32_file_name" "$win32_url"
echo "> done"

echo "> compiling $linux_file_name..."
npx node-pre-gyp install --fallback-to-build --target_platform=linux --target_arch=x64
mv src/binding/usb_bindings.node "$binding_dir/$linux_file_name"
echo "> done"
