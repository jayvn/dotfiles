#!/bin/bash

# Allow unfree packages
export NIXPKGS_ALLOW_UNFREE=1

# Fetch installed packages in JSON format
# Filter to only include packages that have a flake URL (installed via nix profile add)
PACKAGES=$(nix profile list --json | python3 -c "
import sys, json
data = json.load(sys.stdin)
flake_pkgs = [name for name, details in data['elements'].items() if 'originalUrl' in details or 'url' in details]
print(' '.join(flake_pkgs))
")

if [ -z "$PACKAGES" ]; then
    echo "No flake-based packages found in Nix profile."
    exit 0
fi

echo "Found flake-based packages: $PACKAGES"
echo "Starting upgrade..."

# Iterate through each package and upgrade
for pkg in $PACKAGES; do
    echo "------------------------------------------"
    echo "Upgrading $pkg..."
    nix profile upgrade "$pkg" --impure
done

echo "------------------------------------------"
echo "Upgrade process complete."

echo "------------------------------------------"
echo "Cleaning up old generations and collecting garbage..."
nix-collect-garbage --delete-older-than 14d
