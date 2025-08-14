{ pkgs ? import <nixpkgs> {} }:
pkgs.buildEnv {
 name = "desktop-packages";
 paths = with pkgs; [
   # Media & Graphics
   audacity
   gimp
   krita
   vlc
   # kdenlive
   
   # Web Browsers
   firefox
   ungoogled-chromium
   
   # Development
   vscode
   
   # Office & Productivity
   calibre
   gnumeric
   filezilla
   
   # Games
   warzone2100
 ];
}
