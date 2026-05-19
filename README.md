# bootloader32

## Overview
`os_bootloqder` is a simple operating system bootloader that demonstrates how to:
- Switch the CPU into 32‑bit protected mode
- Configure the Global Descriptor Table (GDT)
- Provide the groundwork for building a custom operating system

This project is intended for educational purposes and as a starting point for low‑level system programming.

---

## Features
- Initializes 32‑bit protected mode
- Sets up GDT entries for code and data segments
- Provides a clean environment for kernel execution
- Written in Assembly and C for clarity and performance

---

## Requirements
- x86‑64 or x86 CPU (supports protected mode)
- NASM assembler
- GCC or Clang compiler
- QEMU or Bochs for testing

---

## Installation & Build
Clone the repository and build the bootloader:

```bash
git clone https://github.com/er0ex/bootloader32.git
cd bootloader32
make
