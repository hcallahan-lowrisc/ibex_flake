{
  description = "Build and run the ibex simple_system simulation declaratively using Nix!";

  inputs = {

    # fetchPypi = {
    #   url = "git+https://github.com/DavHau/nix-pypi-fetcher";
    # };

    # name = "nix-pypi-fetcher";
    # url = "https://github.com/DavHau/nix-pypi-fetcher/tarball/${commit}";
    # # Hash obtained using `nix-prefetch-url --unpack <url>`
    # sha256 = "1c06574aznhkzvricgy5xbkyfs33kpln7fb41h8ijhib60nharnp";

    mach-nix = {
      url = "mach-nix/3.4.0";
    };

    deps = {
      url = "path:./dependencies";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, mach-nix, deps }:
    let
      system = "x86_64-linux";

      python_overlay = final: prev: {
        python3 = prev.python3.override {
          packageOverrides = deps.overlay_python;
        };
      };
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ python_overlay deps.overlay_pkgs ];
      };

      pythonEnv = pkgs.python3.withPackages(ps: with ps; [ pip fusesoc edalize ]);

      # pyenv = mach-nix.lib.x86_64-linux.mkPython {
      #   requirements = ''
      #     fusesoc=0.3.3.dev
      #   '';
      #   overridesPre = [
      #     (final: prev: {
      #       fusesoc = my_fusesoc;
      #       edalize = my_edalize;
      #     })
      #   ];
      # };


      buildInputs = with pkgs;
        [ verilator libelf srecord riscv-gcc-toolchain ] ++
        [ pythonEnv ];

    in
      {

        ### from... ibex/examples/simple_system/README.md

        # fusesoc --cores-root=. run --target=sim --setup --build lowrisc:ibex:ibex_simple_system --RV32E=0 --RV32M=ibex_pkg::RV32MFast
        # make -C examples/sw/simple_system/hello_test
        # ./build/lowrisc_ibex_ibex_simple_system_0/sim-verilator/Vibex_simple_system [-t] --meminit=ram,./examples/sw/simple_system/hello_test/hello_test.elf

        # defaultPackage.x86_64-linux = simple_system;
        # Construct a shell with all of our dependencies
        devShell.x86_64-linux = pkgs.mkShell {
          name = "simple_system";
          version = "0.1.0";
          src = ./.;
          inherit buildInputs;
          # inputsFrom = buildInputs;
        };
      #   devShells.x86_64-linux.fusesoc = pkgs.mkShell {
      #     name = "fusesoc";
      #     version = "0.1.0";
      #     buildInputs = [ fusesoc_deps ];
      #     # inputsFrom = [ my_fusesoc ]; # Use special "inputsFrom" to get the buildInputs from derivations
      #   };
      };
}
