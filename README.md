# frostOS

A tiny Rust hobby operating system targeting x86_64 PCs. The first milestone boots through GRUB's Multiboot2 interface and prints to the VGA text console.

## Build prerequisites

- Rust and Cargo
- `x86_64-elf-grub-mkrescue`
- `xorriso`

On macOS with Homebrew:

```sh
brew install x86_64-elf-grub xorriso
rustup target add x86_64-unknown-none
```

## Build the ISO

From the repository root:

```sh
chmod +x build.sh
./build.sh
```

This produces `frostOS.iso`. The kernel uses a small 32-bit assembly entry point to establish paging and switch the CPU into long mode before calling the Rust kernel. GRUB loads it using Multiboot2.

## Boot in UTM

This initial image targets a legacy BIOS-style x86_64 PC VM and VGA text output; it is not an ARM/Apple Silicon-native kernel and does not boot through UEFI yet.

1. In UTM, create an **Emulate** VM with the **x86_64** architecture (not an ARM virtualized guest).
2. Use a standard PC/VGA-compatible machine/display and attach `frostOS.iso` as the CD/DVD boot image.
3. Start the VM and select frostOS in GRUB if the menu appears.

The console should show `Hello, frostOS!` and a second line confirming the boot path. This project has not been tested in UTM yet; if it fails, share the exact build output or what appears on screen so we can diagnose it.

## Current console

The first console writes directly to the classic 80x25 VGA text buffer, handles newlines and scrolling, and updates the hardware text cursor. This is a legacy PC console; later we can add a framebuffer console for UEFI and modern virtual graphics devices.

## Next milestones

- keyboard input
- interrupts and exception reporting
- framebuffer support
- memory management
- a simple shell
