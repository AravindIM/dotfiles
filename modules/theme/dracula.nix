{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    fira-code
  ];
  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Tela-dark";
      package = pkgs.tela-icon-theme;
    };
    font = {
      name = "FiraCode";
    };
  };
}
