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
            catppuccin-nvim
            gitsigns-nvim
            lze
            nvim-treesitter.withAllGrammars
            plenary-nvim # library; harpoon2 requires it while being loaded
            snacks-nvim
          ];

          # plugins loaded on demand by lze
          config.specs.lazy = {
            lazy = true;
            data = with pkgs.vimPlugins; [
              auto-session
              blink-cmp
              bufferline-nvim
              conform-nvim
              flash-nvim
              harpoon2
              lazygit-nvim
              lspsaga-nvim
              lualine-nvim
              mini-nvim
              noice-nvim
              nvim-lint
              nvim-lspconfig
              smart-splits-nvim
              stay-centered-nvim
              which-key-nvim
            ];
          };

          config.runtimePkgs = map (p: {
            data = p;
            prefix = true;
          }) (with pkgs; [
            cabal-install
            cargo
            clippy
            deadnix
            eslint
            fd
            fourmolu
            ghc
            git
            haskell-language-server
            hlint
            lazygit
            lua-language-server
            nixd
            nixfmt
            prettier
            pyright
            python3
            ripgrep
            ruff
            rust-analyzer
            rustc
            rustfmt
            statix
            taplo
            typescript-language-server
            vscode-langservers-extracted
            yamllint
            yaml-language-server
          ]);
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
