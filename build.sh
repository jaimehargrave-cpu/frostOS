#!/usr/bin/env bash
set -euo pipefail

RUSTFLAGS="-C link-arg=-Tlinker.ld" cargo build --target x86_64-unknown-none.json --release

mkdir -p iso/boot/grub
cp target/x86_64-unknown-none/release/frostOS iso/boot/kernel.bin
cp grub.cfg iso/boot/grub/grub.cfg

GRUB_MKRESCUE="${GRUB_MKRESCUE:-x86_64-elf-grub-mkrescue}"
"$GRUB_MKRESCUE" -o frostOS.iso iso
