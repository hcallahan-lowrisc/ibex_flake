final: prev: {
  riscv-gcc-toolchain = prev.callPackage ./riscv-gcc-lowrisc.nix {};
  riscv-isa-sim = prev.callPackage ./riscv-isa-sim.nix {};
}
