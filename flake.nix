{
  description = "Nix flake templates for project dev shells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.git-hooks.flakeModule
      ];

      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      perSystem =
        { config, ... }:
        {
          treefmt = {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
            settings.global.excludes = [ "*.lock" ];
          };

          pre-commit.settings.hooks = {
            treefmt = {
              enable = true;
              package = config.treefmt.build.wrapper;
            };
            deadnix.enable = true;
            statix.enable = true;
          };

          devShells.default = config.pre-commit.devShell;
        };

      flake.templates = {
        java8-maven = {
          path = ./java8-maven;
          description = "Java 8 (Zulu) + Maven + PostgreSQL 18 dev shell (direnv-ready)";
          welcomeText = ''
            # java8-maven dev shell

            Run `direnv allow` to enter the shell. Start PostgreSQL with `pg-start`.
          '';
        };
        java11-maven = {
          path = ./java11-maven;
          description = "Java 11 (Zulu) + Maven + PostgreSQL 18 dev shell (direnv-ready)";
          welcomeText = ''
            # java11-maven dev shell

            Run `direnv allow` to enter the shell. Start PostgreSQL with `pg-start`.
          '';
        };
        java17-maven = {
          path = ./java17-maven;
          description = "Java 17 (Zulu) + Maven + PostgreSQL 18 dev shell (direnv-ready)";
          welcomeText = ''
            # java17-maven dev shell

            Run `direnv allow` to enter the shell. Start PostgreSQL with `pg-start`.
          '';
        };
        java21-maven = {
          path = ./java21-maven;
          description = "Java 21 (Zulu) + Maven + PostgreSQL 18 dev shell (direnv-ready)";
          welcomeText = ''
            # java21-maven dev shell

            Run `direnv allow` to enter the shell. Start PostgreSQL with `pg-start`.
          '';
        };
        java25-maven = {
          path = ./java25-maven;
          description = "Java 25 (Zulu) + Maven + PostgreSQL 18 dev shell (direnv-ready)";
          welcomeText = ''
            # java25-maven dev shell

            Run `direnv allow` to enter the shell. Start PostgreSQL with `pg-start`.
          '';
        };
      };
    };
}
