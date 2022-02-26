#!/bin/bash

set -e

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

source "${SCRIPT_DIR}/utils.sh"

if [ ! -f "${FILE}" ]; then
    echo "File not found: ${FILE}"
    exit 1
fi

cp "${FILE}" "${FILE_CPIO_GZ}"
gzip -d "${FILE_CPIO_GZ}"

reset_ramdisk

cd "${RAMDISK_DIR}"
cat "${FILE_CPIO}" | sudo "${CPIO}" -i -d --no-absolute-filenames
cd "${PWD}"

rm "${FILE_CPIO}"

echo "Done, edit your stuff in ${RAMDISK_DIR}"
