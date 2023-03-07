{ config, pkgs, ...}:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = false;
    withPython3 = true;
    extraConfig = ''
        let g:coc_data_home = $HOME . '/.config/coc'
        set expandtab
        set tabstop=4
        set shiftwidth=4
      '';
    coc.enable = true;
    extraPackages = with pkgs; [
      nodePackages.bash-language-server
      nodePackages.yaml-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.prettier
      nixpkgs-fmt
      terraform
    ];
    plugins = with pkgs.vimPlugins; [
      vim-nix
      vim-lastplace
      vim-markdown
      markdown-preview-nvim
      nvim-jdtls
      coc-nvim
      coc-css
      coc-explorer
      coc-git
      coc-go
      coc-html
      coc-json
      coc-prettier
      coc-pyright
      coc-yaml
      copilot-vim
      vim-surround
    ];
  };
}

