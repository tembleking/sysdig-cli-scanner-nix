{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    utils,
  }:
    utils.lib.eachDefaultSystem (
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
}
