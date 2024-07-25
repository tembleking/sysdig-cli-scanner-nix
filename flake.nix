{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    utils,
  }: let
    eachSystem = utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        sysdig-cli-scanner = pkgs.callPackage ./sysdig-cli-scanner.nix {};
      in {
        packages = {
          inherit sysdig-cli-scanner;
          default = sysdig-cli-scanner;
        };

        formatter = pkgs.alejandra;
      }
    );

    overlays = {
      default = final: prev: {
        sysdig-cli-scanner = self.packages.${final.system}.sysdig-cli-scanner;
      };
    };
  in
    eachSystem // {inherit overlays;};
}
