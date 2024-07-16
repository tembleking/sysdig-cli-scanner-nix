{
  stdenv,
  fetchurl,
}: let
  version = "1.12.0";

  buildUrl = os: arch: "https://download.sysdig.com/scanning/bin/sysdig-cli-scanner/${version}/${os}/${arch}/sysdig-cli-scanner";
  fetchForSystem =
    {
      "x86_64-linux" = {
        url = buildUrl "linux" "amd64";
        hash = "sha256-Vyi/gRHFQmosLTv0GGi9esypUKVWDVCsE+auDog8T/k=";
      };
      "aarch64-linux" = {
        url = buildUrl "linux" "arm64";
        hash = "sha256-wlnNtohrFF0E72vIL8oygykJ17fac8qA7B3+2M57GHs=";
      };
      "x86_64-darwin" = {
        url = buildUrl "darwin" "amd64";
        hash = "sha256-oeBaRprHFW4AvyRbqgaP27iXAWwysgzlOLoKjevYN1Y=";
      };
      "aarch64-darwin" = {
        url = buildUrl "darwin" "arm64";
        hash = "sha256-C0kmIEXZUgkXjgPzlNqQAgZkodUYIJXb9GGivfgjV6c=";
      };
    }
    .${stdenv.system}
    or (throw "unsupported system ${stdenv.system}");
in
  stdenv.mkDerivation {
    pname = "sysdig-cli-scanner";
    inherit version;

    src = fetchurl {
      inherit (fetchForSystem) url hash;
    };

    phases = ["installPhase"];

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/sysdig-cli-scanner
      chmod +x $out/bin/sysdig-cli-scanner
    '';
  }
