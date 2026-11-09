#!/usr/bin/env bash
set -euo pipefail

cargo build --release

mkdir -p iso/boot/grub
cp target/x86_64-unknown-none/release/frostOS iso/boot/kernel.elf
cp grub.cfg iso/boot/grub/grub.cfg

GRUB_MKRESCUE="${GRUB_MKRESCUE:-x86_64-elf-grub-mkrescue}"
command -v "$GRUB_MKRESCUE" >/dev/null 2>&1 || {
    echo "Cannot find $GRUB_MKRESCUE. Install x86_64-elf-grub or set GRUB_MKRESCUE." >&2
    exit 1
}
"$GRUB_MKRESCUE" -o frostOS.iso iso
