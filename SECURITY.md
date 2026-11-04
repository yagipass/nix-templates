# Security

## Reporting a vulnerability

Report vulnerabilities privately through [GitHub's private vulnerability reporting](https://github.com/yagipass/nix-templates/security/advisories/new). Do not open a public issue.

## Supported versions

There are no releases. Only the templates on `main` receive security fixes. `nix flake init` copies a template into the project, so a fix on `main` does not reach existing projects. Apply template fixes to them by hand. `nix flake update` updates only their dependencies.

## Scope

The templates are for development. Their PostgreSQL server listens only on localhost, has the default password `dev`, and trusts connections through its Unix socket. This is expected behavior, not a vulnerability.
