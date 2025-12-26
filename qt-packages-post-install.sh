#!/bin/bash
#
# Make the Nix desktop files writable and patch them directly
# Copy Nix desktop files to local directory
cp -f ~/.nix-profile/share/applications/*.desktop ~/.local/share/applications/

# Now modify the local copies (these are writable)
for file in ~/.local/share/applications/*.desktop; do
    if grep -Eq "(krita|calibre|kdenlive)" "$file"; then
        sed -i 's|^Exec=\([^e][^n][^v]\)|Exec=env QT_XCB_GL_INTEGRATION=none \1|' "$file"
    fi
done

# Make them executable
chmod +x ~/.local/share/applications/*.desktop
