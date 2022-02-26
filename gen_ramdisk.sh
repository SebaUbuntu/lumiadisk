#!/bin/bash

set -e

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

source "${SCRIPT_DIR}/utils.sh"

reset_ramdisk

create_root_folders
create_busybox_symlinks

copy_executable "etc/init"
copy_executable "prebuilts/busybox" "sbin"
copy_executable "prebuilts/libaroma" "usr/bin"
copy_file "etc/res.zip" "usr/bin"

echo "Done!"
