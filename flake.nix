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

          # plugins that must be loaded at startup
          config.specs.startup = with pkgs.vimPlugins; [
            lze
            nvim-treesitter.withAllGrammars
          ];

          # plugins loaded on demand by lze
          config.specs.lazy = {
            lazy = true;
            data = with pkgs.vimPlugins; [
              blink-cmp
              conform-nvim
              fzf-lua
              lspsaga-nvim
              nvim-lint
              nvim-lspconfig
              trouble-nvim
            ];
          };

          config.runtimePkgs = with pkgs; [
            deadnix
            fd
            fzf
            lua-language-server
            nixd
            nixfmt
            ripgrep
            statix
            stylua
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
