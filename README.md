# My personal collection of flake templates

## Usage

```sh
nix flake init -t "github:yagipass/nix-templates#java8-maven"
direnv allow
```

## Templates

| Name | Contents |
| --- | --- |
| `java8-maven` | Java 8 (Zulu) + Maven + PostgreSQL 18. Includes helper commands such as `pg-start` / `pg-stop` |
| `java11-maven` | Java 11 (Zulu) + Maven + PostgreSQL 18. Includes helper commands such as `pg-start` / `pg-stop` |
| `java17-maven` | Java 17 (Zulu) + Maven + PostgreSQL 18. Includes helper commands such as `pg-start` / `pg-stop` |
| `java21-maven` | Java 21 (Zulu) + Maven + PostgreSQL 18. Includes helper commands such as `pg-start` / `pg-stop` |
| `java25-maven` | Java 25 (Zulu) + Maven + PostgreSQL 18. Includes helper commands such as `pg-start` / `pg-stop` |

## Formatting and linting

The root flake provides a dev shell that installs a pre-commit hook. Run
`direnv allow` (or `nix develop`) in the repository root once to install it.
The hook runs treefmt (nixfmt), deadnix, and statix on staged files.

```sh
nix fmt            # format everything
nix flake check .  # formatting + deadnix + statix + template evaluation (what CI runs)
```

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
