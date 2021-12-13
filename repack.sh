#!/bin/bash

set -e

PWD="$(pwd)"
FILE="${PWD}/initramfs.img"
FILE_CPIO_GZ="${PWD}/initramfs.cpio.gz"
FILE_CPIO="${PWD}/initramfs.cpio"
RAMDISK_DIR="${PWD}/ramdisk"
CPIO="${PWD}/cpio"

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
