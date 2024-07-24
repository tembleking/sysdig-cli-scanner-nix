{
  stdenv,
  fetchurl,
}: let
  versionMetadata = builtins.fromTOML (builtins.readFile ./sysdig-cli-scanner.versions.toml);
  fetchForSystem = versionMetadata.${stdenv.system} or (throw "unsupported system ${stdenv.system}");
in
  stdenv.mkDerivation {
    pname = "sysdig-cli-scanner";
    version = versionMetadata.version;

    src = fetchurl {
      inherit (fetchForSystem) url hash;
    };

    phases = ["installPhase"];

    installPhase = ''
      install -D $src $out/bin/sysdig-cli-scanner
    '';
  }
