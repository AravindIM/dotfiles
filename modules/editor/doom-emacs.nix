{ config, pkgs, ...}:
{
  home.packages = with pkgs; [
    fira-code
    fira-code-symbols
    ripgrep
    fd
  ];

    programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./doom.d;
  };
  services.emacs.enable = true;
}

