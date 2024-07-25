# Sysdig CLI Scanner Nix Flake

This repository provides a Nix flake for managing [Sysdig's sysdig-cli-scanner](https://docs.sysdig.com/en/docs/installation/sysdig-secure/#vulnerability-pipeline-scanning) on Nix-based systems.

The `sysdig-cli-scanner` is a versatile tool used for scanning container images and directories, whether they are located locally or remotely. It supports both Vulnerability Management (VM) mode for image scanning and Infrastructure as Code (IaC) mode for scanning directories.

## Installation

To install the sysdig-cli-scanner package using this flake:

### In non-NixOS systems

Use Nix to install the package in your profile:

```sh
nix profile install github:tembleking/sysdig-cli-scanner-nix#sysdig-cli-scanner
````

### In NixOS systems

Add this flake as an input in your `flake.nix`:

```nix
{
    inputs = {
        sysdig-cli-scanner = {
              url = "github:tembleking/sysdig-cli-scanner-nix";
              inputs.nixpkgs.follows = "nixpkgs";
        };
    };
}
```

Add the overlay and the package to your `configuration.nix`:

```nix
{
    config,
    pkgs,
    ...
}@ inputs: {
    nixpkgs.overlays = [ inputs.sysdig-cli-scanner.overlays.default ];

    environment.systemPackages = [
      sysdig-cli-scanner  
    ];
}
```

## Running the scanner

You can run sysdig-cli-scanner to scan images or IaC resources:

### For VM mode (Image Scanning)

```sh
SECURE_API_TOKEN=<your-api-token> sysdig-cli-scanner --apiurl <sysdig-api-url> <image-name>
```

### For IaC mode (Directory Scanning)

```sh
SECURE_API_TOKEN=<your-api-token> sysdig-cli-scanner --iac --apiurl <sysdig-api-url> <path-to-scan>
```

## Documentation

For other usage examples, refer to the [official Sysdig CLI Scanner documentation](https://docs.sysdig.com/en/docs/installation/sysdig-secure/install-vulnerability-cli-scanner/).
