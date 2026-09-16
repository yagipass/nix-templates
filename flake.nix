{
  description = "Nix flake templates for project dev shells";

  outputs = _: {
    templates = {
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
