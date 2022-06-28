{
  description = "ibex simple_system dependencies";

  inputs = {

    lowrisc_fusesoc_src = {
#    url = "path:/home/harrycallahan/projects/fusesoc/";
     url = "github:lowRISC/fusesoc?ref=ot-0.2";
     flake = false;
    };
    lowrisc_edalize_src = {
#    url = "path:/home/harrycallahan/projects/fusesoc/";
     url = "github:lowRISC/edalize?ref=ot-0.2";
     flake = false;
    };
  };

  outputs = {
    self, nixpkgs,
    lowrisc_fusesoc_src,
    lowrisc_edalize_src,
  }:
    let
      local_overlay = import ./overlay.nix;
      local_python_overlay = import ./python-overlay.nix;

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

    in
      {
        overlay_pkgs = local_overlay;
        overlay_python = nixpkgs.lib.composeManyExtensions [
          local_python_overlay
          lowRISC_python_overrides
        ];
      };
}
