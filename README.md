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

The `javaN-maven` templates are identical except for the JDK (`pkgs.zuluN`). When changing one, apply the same change to all of them.

### PostgreSQL connection settings

The role, database, and password all default to `dev`. Export these variables
before entering the dev shell to override them:

```sh
export DEVSHELL_PG_USER=myapp
export DEVSHELL_PG_DATABASE=myapp
export DEVSHELL_PG_PASSWORD=myapp
```

Use plain identifiers without quotes; the values are embedded into SQL as-is.
The values are fixed when `pg-start` first initializes the data directory. To
change them afterwards, run `pg-stop`, delete `.postgres`, and run `pg-start`
again. `pg-init` warns when the shell's values differ from the ones used at
initialization.

## Updating flake.lock

```sh
for t in java*-maven; do nix flake update --flake "./$t"; done
```

After updating, run the verification commands below before committing.

A template's flake.lock is only the source that gets copied, so the update only
affects projects that run `nix flake init` from then on. To update a project that
has already been initialized, run `nix flake update` in that project's root.

## Verifying the templates

The templates are flakes themselves, so verify changes with:

```sh
nix flake check .
for t in java*-maven; do
  nix flake check "./$t"
  nix develop "./$t" --command true
done
```

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE).
