# nix-templates

[![CI](https://github.com/yagipass/nix-templates/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/yagipass/nix-templates/actions/workflows/ci.yml?query=branch%3Amain)
[![License](https://img.shields.io/github/license/yagipass/nix-templates)](LICENSE)

My personal collection of Nix flake templates for project dev shells.

## Usage

```sh
nix flake init -t "github:yagipass/nix-templates#java8-maven"
direnv allow
```

Then add `.direnv/` and `.postgres/` to the project's `.gitignore`.

## Templates

Each template provides a dev shell with a JDK, Maven, and PostgreSQL 18.

| Template | JDK |
|---|---|
| `java8-maven` | Zulu 8 |
| `java11-maven` | Zulu 11 |
| `java17-maven` | Zulu 17 |
| `java21-maven` | Zulu 21 |
| `java25-maven` | Zulu 25 |

## PostgreSQL

`pg-start`, `pg-stop`, `pg-status`, and `pg-where` manage a server for the project. The dev shell lists them when you enter it. The first `pg-start` creates the data directory `.postgres/` in the project.

- The role, database, and password are all `dev`. To use others, set `DEVSHELL_PG_USER`, `DEVSHELL_PG_DATABASE`, and `DEVSHELL_PG_PASSWORD` before entering the shell. A change applies only to a new `.postgres/`.
- The server listens on `localhost:5432`, so only one project's server can run at a time. `pg-where` shows which project's server is running, unless the project path contains a space.
- `pg-start` fails if the socket path `<project>/.postgres/.s.PGSQL.5432` is too long for the OS, which allows 103 bytes on macOS.

## Development

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

nix-templates is licensed under the [MIT License](LICENSE).
