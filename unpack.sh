#!/bin/bash

set -e

PWD="$(pwd)"
FILE="${PWD}/initramfs.img"
FILE_CPIO_GZ="${PWD}/initramfs.cpio.gz"
FILE_CPIO="${PWD}/initramfs.cpio"
RAMDISK_DIR="${PWD}/ramdisk"
CPIO="${PWD}/cpio"

if [ ! -f "${FILE}" ]; then
    echo "File not found: ${FILE}"
    exit 1
fi

cp "${FILE}" "${FILE_CPIO_GZ}"
gzip -d "${FILE_CPIO_GZ}"

if [ -d "${RAMDISK_DIR}" ]; then
    sudo rm -rf "${RAMDISK_DIR}"
fi
mkdir -p "${RAMDISK_DIR}"

cd "${RAMDISK_DIR}"
cat "${FILE_CPIO}" | sudo "${CPIO}" -i -d --no-absolute-filenames
cd "${PWD}"

rm "${FILE_CPIO}"

echo "Done, edit your stuff in ${RAMDISK_DIR}"
