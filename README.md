# frostOS

A tiny Rust hobby operating system targeting x86_64 and booting in UTM or any compatible x86_64 VM or machine.

## Goal

The first milestone is a simple, bootable kernel that prints `Hello, frostOS!` on the screen.

## Prerequisites

- Rust toolchain
- `x86_64-elf-grub-mkrescue` (provided by the Homebrew `x86_64-elf-grub` formula on macOS)
- `xorriso`

Install Rust:

```bash
rustup-init
rustup target add x86_64-unknown-none
```

On macOS with Homebrew:

```bash
brew install x86_64-elf-grub xorriso
```

The Homebrew GRUB tool is prefixed, so `build.sh` uses `x86_64-elf-grub-mkrescue` by default. If your installation provides the tool under another name or path, set `GRUB_MKRESCUE` when building, for example:

```bash
GRUB_MKRESCUE=/path/to/grub-mkrescue ./build.sh
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
