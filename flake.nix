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

          # Remote plugin hosts pull full language runtimes into the closure.
          # Runtimes are system-provided; disable the bundled hosts.
          config.hosts.python3.nvim-host.enable = false;
          config.hosts.ruby.nvim-host.enable = false;
          config.hosts.perl.nvim-host.enable = false;
          config.hosts.node.nvim-host.enable = false;

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
              conform-nvim
              flash-nvim
              friendly-snippets
              harpoon2
              heirline-nvim
              lazygit-nvim
              lspsaga-nvim
              mini-nvim
              noice-nvim
              nvim-lint
              nvim-lspconfig
              nvim-navic
              nvim-treesitter-textobjects
              smart-splits-nvim
              stay-centered-nvim
              which-key-nvim
              SchemaStore-nvim
            ];
          };

          # Only LSPs, formatters and linters belong here. Language runtimes
          # and toolchains are provided by the system. HLS and rustfmt are also
          # system-provided because their nix packages pull in GHC/rustc.
          config.runtimePkgs = map (p: {
            data = p;
            prefix = true;
          }) (with pkgs; [
            eslint
            fd
            fourmolu
            hlint
            lazygit
            lua-language-server
            nil
            nixfmt
            prettier
            python3
            ripgrep
            ruff
            rust-analyzer
            statix
            taplo
            ty
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
