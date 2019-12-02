# Picobello

A disassembler and (eventually, hopefully) assembler for the Microchip PIC instruction set, written in Swift.

## Status

Very experimental, incomplete, and untested. Currently only the disassembler is functional. And I only support the PIC10F20x instruction set for now.

![](https://github.com/ole/Picobello/workflows/macOS/badge.svg) ![](https://github.com/ole/Picobello/workflows/Linux/badge.svg)

## Usage

The executable is called "picob".

### Disassemble a .hex File

```sh
$ swift run picob disassemble <path-to-hex.hex>
```

If you don't have a .hex file at hand, you can pass the `--sample` flag to disassemble a hardcoded sample file:

```sh
$ swift run picob disassemble --sample
```

### Print Usage Information

```sh
$ swift run picob --help
OVERVIEW: PIC instruction set assembler

USAGE: picob <command>

OPTIONS:
--version, -v   Print version information and exit
--help          Display available options

SUBCOMMANDS:
disassemble     Disassemble a .hex file
```

## Author

Ole Begemann, [oleb.net](https://oleb.net).

## License

MIT. See [LICENSE.txt](LICENSE.txt).
