#![no_std]
#![no_main]

use core::panic::PanicInfo;
use core::ptr::{read_volatile, write_volatile};

core::arch::global_asm!(include_str!("boot.S"));

const WIDTH: usize = 80;
const HEIGHT: usize = 25;
const VGA: *mut u16 = 0xb8000 as *mut u16;
const COLOR: u8 = 0x0f;

struct Console {
    column: usize,
    row: usize,
}

impl Console {
    const fn new() -> Self {
        Self { column: 0, row: 0 }
    }

    fn write_str(&mut self, text: &str) {
        for byte in text.bytes() {
            self.write_byte(byte);
        }
        self.update_hardware_cursor();
    }

    fn write_byte(&mut self, byte: u8) {
        match byte {
            b'\n' => {
                self.column = 0;
                self.row += 1;
            }
            b'\r' => self.column = 0,
            byte => {
                self.put(self.column, self.row, byte);
                self.column += 1;
                if self.column == WIDTH {
                    self.column = 0;
                    self.row += 1;
                }
            }
        }

        if self.row >= HEIGHT {
            self.scroll();
        }
    }

    fn put(&self, column: usize, row: usize, byte: u8) {
        let cell = ((COLOR as u16) << 8) | byte as u16;
        unsafe { write_volatile(VGA.add(row * WIDTH + column), cell) };
    }

    fn scroll(&mut self) {
        for row in 1..HEIGHT {
            for column in 0..WIDTH {
                let from = unsafe { read_volatile(VGA.add(row * WIDTH + column)) };
                unsafe { write_volatile(VGA.add((row - 1) * WIDTH + column), from) };
            }
        }
        for column in 0..WIDTH {
            self.put(column, HEIGHT - 1, b' ');
        }
        self.row = HEIGHT - 1;
    }

    fn update_hardware_cursor(&self) {
        let position = (self.row * WIDTH + self.column) as u16;
        unsafe {
            outb(0x3d4, 0x0f);
            outb(0x3d5, position as u8);
            outb(0x3d4, 0x0e);
            outb(0x3d5, (position >> 8) as u8);
        }
    }
}

unsafe fn outb(port: u16, value: u8) {
    core::arch::asm!(
        "out dx, al",
        in("dx") port,
        in("al") value,
        options(nomem, nostack, preserves_flags)
    );
}

#[no_mangle]
pub extern "C" fn frostos_main() -> ! {
    let mut console = Console::new();
    console.write_str("Hello, frostOS!\n");
    console.write_str("Booted via GRUB Multiboot2 on x86_64.\n");

    loop {
        unsafe { core::arch::asm!("hlt", options(nomem, nostack)) };
    }
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    let mut console = Console::new();
    console.write_str("frostOS kernel panic\n");
    loop {
        unsafe { core::arch::asm!("hlt", options(nomem, nostack)) };
    }
}
