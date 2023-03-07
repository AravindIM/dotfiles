{ lib, inputs, system, home-manager, user, doom-emacs, hyprland, ... }:

{
  thinkpad = lib.nixosSystem {
    inherit system;
    specialArgs = { inherit user inputs doom-emacs hyprland;};
    modules = [
      hyprland.nixosModules.default
      ./thinkpad/configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user doom-emacs hyprland;};
        home-manager.users.${user} = {
          imports = [
            ./thinkpad/home.nix
            ../modules/desktop/hyprland/home.nix
            ../modules/theme/dracula.nix
            doom-emacs.hmModule
          ] ++ (import ../modules/shell)
          ++ (import ../modules/editor);
        };
      }
    ] ++ [(import ../modules/desktop/hyprland)];
  };
}
