#!/bin/bash

set -e

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

source "${SCRIPT_DIR}/utils.sh"

if [ ! -d "${RAMDISK_DIR}" ]; then
    echo "Error: ${RAMDISK_DIR} does not exist"
    exit 1
fi

cd "${RAMDISK_DIR}"
$sudo find . | sudo "${CPIO}" -H newc -o 2>/dev/null | cat > "${FILE_CPIO}"
cd "${PWD}"

gzip "${FILE_CPIO}"

mv "${FILE_CPIO_GZ}" "${FILE}"

echo "Done, your ramdisk is ${FILE}"
