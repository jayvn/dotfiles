{ pkgs ? import <nixpkgs> {} }:
pkgs.buildEnv {
 name = "desktop-packages";
 paths = with pkgs; [
   # Media & Graphics
   audacity
   gimp
   krita
   vlc
   kdePackages.kdenlive
   calibre

   # Web Browsers
   firefox
   ungoogled-chromium
   
   # Development
   vscode
   
   # Office & Productivity
   gnumeric
   filezilla
   krita
   
   # Games
   warzone2100
 ];
}
