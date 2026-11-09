#!/usr/bin/env bash
set -euo pipefail

cargo build --target x86_64-unknown-none.json --release

mkdir -p iso/boot/grub
cp target/x86_64-unknown-none/release/frostOS iso/boot/kernel.bin
cp grub.cfg iso/boot/grub/grub.cfg

grub-mkrescue -o frostOS.iso iso
