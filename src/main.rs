#![no_std]
#![no_main]

use core::panic::PanicInfo;

#[no_mangle]
pub extern "C" fn _start() -> ! {
    let vga = 0xb8000 as *mut u8;
    let message = b"Hello, frostOS!";

    for (i, &byte) in message.iter().enumerate() {
        unsafe {
            vga.add(i * 2).write_volatile(byte);
            vga.add(i * 2 + 1).write_volatile(0x0f);
        }
    }

    loop {}
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
