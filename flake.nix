{
  description = "Flake exporting a configured neovim package";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.wrappers.url = "github:nix-community/nix-wrapper-modules";
  inputs.wrappers.inputs.nixpkgs.follows = "nixpkgs";
  outputs =
    {
      self,
      nixpkgs,
      wrappers,
      ...
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.all;
      module =
        {
          config,
          wlib,
          pkgs,
          ...
        }:
        {
          imports = [ wlib.wrapperModules.neovim ];

          config.settings.config_directory = ./.;

          config.specs.default = {
            data = with pkgs.vimPlugins; [
              lze
              nvim-treesitter.withAllGrammars
            ];
          };

          config.specs.lspconfig = {
            lazy = true;
            data = pkgs.vimPlugins.nvim-lspconfig;
          };

          config.specs.blink-cmp = {
            lazy = true;
            data = pkgs.vimPlugins.blink-cmp;
          };

          config.specs.fzf-lua = {
            lazy = true;
            data = pkgs.vimPlugins.fzf-lua;
          };

          config.specs.lspsaga = {
            lazy = true;
            data = pkgs.vimPlugins.lspsaga-nvim;
          };

          config.specs.trouble = {
            lazy = true;
            data = pkgs.vimPlugins.trouble-nvim;
          };

          config.runtimePkgs = with pkgs; [
            fd
            fzf
            lua-language-server
            nixd
            ripgrep
          ];
        };
      wrapper = wrappers.lib.evalModule module;
    in
    {
      wrapperModules = {
        neovim = module;
        default = self.wrapperModules.neovim;
      };
      wrappers = {
        neovim = wrapper.config;
        default = self.wrappers.neovim;
      };
      overlays = {
        neovim = final: prev: { neovim = self.wrappers.neovim.wrap { pkgs = final; }; };
        default = self.overlays.neovim;
      };
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          neovim = self.wrappers.neovim.wrap { inherit pkgs; };
          default = self.packages.${system}.neovim;
        }
      );
      nixosModules = {
        default = self.nixosModules.neovim;
        neovim = wrappers.lib.getInstallModule {
          name = "neovim";
          value = module;
        };
      };
      homeModules = {
        default = self.homeModules.neovim;
        neovim = self.nixosModules.neovim;
      };
    };
}
