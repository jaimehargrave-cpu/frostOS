# frostOS

A tiny Rust hobby operating system targeting x86_64 and booting in UTM or any compatible x86_64 VM or machine.

## Goal

The first milestone is a simple, bootable kernel that prints `Hello, frostOS!` on the screen.

## Prerequisites

- Rust toolchain
- `grub-mkrescue`
- `xorriso`

Install Rust:

```bash
rustup-init
rustup target add x86_64-unknown-none
```

On macOS with Homebrew:

```bash
brew install grub xorriso
```

## Build

```bash
chmod +x build.sh
./build.sh
```

This creates `frostOS.iso`.

## Run in UTM

1. Open UTM.
2. Create a new Linux VM.
3. Choose a 64-bit x86_64 guest.
4. Attach `frostOS.iso` as the boot disk.
5. Start the VM.

You should see the boot menu and then the greeting text.

## Next milestones

- text console with cursor
- keyboard input
- interrupt handling
- simple shell
- memory management
- multitasking
