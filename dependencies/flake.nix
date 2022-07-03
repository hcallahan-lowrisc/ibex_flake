{
  description = "ibex simple_system dependencies";

  inputs = {

    lowrisc_fusesoc_src = {
      url = "path:/home/harry/projects/fusesoc/";
     # url = "github:lowRISC/fusesoc?ref=ot-0.2";
     flake = false;
    };
    lowrisc_edalize_src = {
      url = "path:/home/harry/projects/edalize/";
     # url = "github:lowRISC/edalize?ref=ot-0.2";
     flake = false;
    };
  };

  outputs = {
    self, nixpkgs,
    lowrisc_fusesoc_src,
    lowrisc_edalize_src,
  }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      lowRISC_python_overrides = pfinal: pprev: {
        fusesoc = pprev.fusesoc.overridePythonAttrs (oldAttrs: {
          version = "0.3.3.dev";
          src = lowrisc_fusesoc_src;
        });
        edalize = pprev.edalize.overridePythonAttrs (oldAttrs: {
          version = "0.3.3.dev";
          src = lowrisc_edalize_src;
        });
      };

      lowRISC_spike_override = final: prev: {
        riscv-isa-sim = prev.riscv-isa-sim.overrideAttrs (oldAttrs: rec {
          version = "ibex-cosim-v0.3";
          src = pkgs.fetchFromGitHub {
            owner = "lowrisc";
            repo = oldAttrs.pname;
            rev = version;
            sha256 = "sha256-pKuOpzybOI8UqWV1TSFq4hqTHf7Bft/3WL19fRpwmfU=";
          };
        });
      };

    in
      {
        overlay_pkgs = pkgs.lib.composeManyExtensions [
          (import ./overlay.nix)
          lowRISC_spike_override
        ];
        overlay_python = pkgs.lib.composeManyExtensions [
          (import ./python-overlay.nix)
          lowRISC_python_overrides
        ];
      };
}
