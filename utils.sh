#!/bin/bash

set -e

PWD="$(pwd)"
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

FILE="${SCRIPT_DIR}/initramfs.img"
FILE_CPIO_GZ="${SCRIPT_DIR}/initramfs.cpio.gz"
FILE_CPIO="${SCRIPT_DIR}/initramfs.cpio"
RAMDISK_DIR="${SCRIPT_DIR}/ramdisk"
CPIO="${SCRIPT_DIR}/cpio"

reset_ramdisk() {
    if [ -d "${RAMDISK_DIR}" ]; then
        sudo rm -rf "${RAMDISK_DIR}"
    fi
    mkdir -p "${RAMDISK_DIR}"
}

create_root_folders() {
    for folder in bin dev mnt proc sbin sys usr/bin usr/sbin; do
        mkdir -p "${RAMDISK_DIR}/${folder}"
    done
}

create_busybox_symlinks() {
    for bin in [ cat chmod chown clear cp cut echo mdev mkdir mknod mount printf reboot sh tar umount which; do
        ln -s busybox "${RAMDISK_DIR}/sbin/${bin}"
    done
}

# $1: source directory
# $2="": relative destination directory
# $3="": stem of the file
copy_file() {
    local src="$1"
    local dst="$2"
    local stem="$3"

    if [ -z "${stem}" ]; then
        stem="$(basename -- "${src}")"
    fi

    local src_dir="${SCRIPT_DIR}/${src}"
    local dst_dir="${RAMDISK_DIR}/${dst}"
    if [ ! -d "${dst_dir}" ]; then
        mkdir -p "${dst_dir}"
    fi

    local dst_file="${dst_dir}/${stem}"
    cp "${src_dir}" "${dst_file}"
    echo "${dst_file}"
}

# $1: source directory
# $2="": relative destination directory
# $3="": stem of the file
copy_executable() {
    dst="$(copy_file "$1" "$2" "$3")"
    chmod +x "${dst}"
}
