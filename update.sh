#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash curl coreutils-full jq

set -euo pipefail

LATEST_VERSION=$(curl -L -s https://download.sysdig.com/scanning/sysdig-cli-scanner/latest_version.txt)
SUPPORTED_OPERATING_SYSTEMS=("linux" "darwin")
SUPPORTED_ARCHITECTURES=("x86_64" "aarch64")
VERSIONS_FILE="sysdig-cli-scanner.versions.toml"

main() {
  echo "version=\"${LATEST_VERSION}\"" > "$VERSIONS_FILE"
  for os in "${SUPPORTED_OPERATING_SYSTEMS[@]}"; do
    for arch in "${SUPPORTED_ARCHITECTURES[@]}"; do
      formatted_arch=$(formatArchitectureForURL "$arch")
      download_url="https://download.sysdig.com/scanning/bin/sysdig-cli-scanner/${LATEST_VERSION}/${os}/${formatted_arch}/sysdig-cli-scanner"
      file_hash=$(fetchFileHash "$download_url")
      appendToVersionsFile "$arch" "$os" "$download_url" "$file_hash"
    done
  done
}

formatArchitectureForURL() {
  local architecture="$1"
  case "$architecture" in
    x86_64) echo "amd64" ;;
    aarch64) echo "arm64" ;;
    *) echo "Unsupported architecture: $architecture" >&2; return 1 ;;
  esac
}

fetchFileHash() {
  local url="$1"
  nix store prefetch-file --json "$url" | jq -r .hash
}

appendToVersionsFile() {
  local architecture="$1"
  local operating_system="$2"
  local url="$3"
  local hash="$4"
  cat >> "$VERSIONS_FILE" << EOF

[${architecture}-${operating_system}]
url="$url"
hash="$hash"
EOF
}

main

