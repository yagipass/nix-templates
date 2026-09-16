{
  description = "Java25/Maven dev shell with PostgreSQL 18 for tests";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        jdk = pkgs.zulu25;
        postgresql = pkgs.postgresql_18;

        pgInit = pkgs.writeShellScriptBin "pg-init" ''
          set -euo pipefail
          marker="$PGDATA/.initialized"
          current="$PGUSER/$PGDATABASE"
          if [[ -f "$marker" ]]; then
            initialized="$(cat "$marker")"
            if [[ "$initialized" != "$current" ]]; then
              echo "pg-init: warning: $PGDATA was initialized as '$initialized' but the shell expects '$current'." >&2
              echo "  To re-initialize: pg-stop; rm -rf '$PGDATA'; pg-start" >&2
            else
              echo "pg-init: already initialized, skipping"
            fi
            exit 0
          fi
          if [[ -d "$PGDATA" ]]; then
            echo "pg-init: error: $PGDATA exists but is incomplete." >&2
            echo "  Run: rm -rf '$PGDATA' && pg-start" >&2
            exit 1
          fi
          echo "pg-init: initializing PostgreSQL 18 at $PGDATA ..."
          ${postgresql}/bin/initdb \
            --username=postgres \
            --locale=C \
            --encoding=UTF8 \
            "$PGDATA" >/dev/null

          echo "listen_addresses = 'localhost'"        >> "$PGDATA/postgresql.conf"
          echo "port = 5432"                           >> "$PGDATA/postgresql.conf"
          echo "unix_socket_directories = '$PGDATA'"  >> "$PGDATA/postgresql.conf"
          echo "logging_collector = on"                >> "$PGDATA/postgresql.conf"
          echo "log_directory = 'log'"                 >> "$PGDATA/postgresql.conf"

          printf '%s\n' \
            'local all all trust' \
            'host  all all 127.0.0.1/32 scram-sha-256' \
            'host  all all ::1/128      scram-sha-256' \
            > "$PGDATA/pg_hba.conf"

          echo "pg-init: starting temporary server to create role $PGUSER / database $PGDATABASE ..."
          mkdir -p "$PGDATA/log"
          ${postgresql}/bin/pg_ctl -D "$PGDATA" -l "$PGDATA/log/init.log" start >/dev/null

          _pg_init_cleanup() {
            ${postgresql}/bin/pg_ctl -D "$PGDATA" stop -m immediate >/dev/null 2>&1 || true
          }
          trap _pg_init_cleanup EXIT

          ${postgresql}/bin/psql -h "$PGDATA" -U postgres -d postgres \
            -c "CREATE ROLE \"$PGUSER\" WITH LOGIN PASSWORD '$PGPASSWORD';"
          ${postgresql}/bin/psql -h "$PGDATA" -U postgres -d postgres \
            -c "CREATE DATABASE \"$PGDATABASE\" OWNER \"$PGUSER\";"

          ${postgresql}/bin/pg_ctl -D "$PGDATA" stop >/dev/null
          trap - EXIT

          echo "$current" > "$marker"
          echo "pg-init: done. run 'pg-start' to launch."
        '';

        pgStart = pkgs.writeShellScriptBin "pg-start" ''
          set -euo pipefail
          pg-init
          if ${postgresql}/bin/pg_ctl -D "$PGDATA" status >/dev/null 2>&1; then
            echo "pg-start: server is already running"
            exit 0
          fi
          mkdir -p "$PGDATA/log"
          ${postgresql}/bin/pg_ctl -D "$PGDATA" -l "$PGDATA/log/server.log" start
        '';

        pgStop = pkgs.writeShellScriptBin "pg-stop" ''
          set -euo pipefail
          ${postgresql}/bin/pg_ctl -D "$PGDATA" stop -m fast
        '';

        pgStatus = pkgs.writeShellScriptBin "pg-status" ''
          ${postgresql}/bin/pg_ctl -D "$PGDATA" status
        '';

        pgWhere = pkgs.writeShellScriptBin "pg-where" ''
          set -euo pipefail
          ps -A -ww -o pid=,command= | awk '
            {
              for (i = 2; i <= NF; i++) {
                if ($i == "-D" && i+1 <= NF) {
                  pgdata = $(i+1)
                  if (pgdata ~ /\/\.postgres($|\/)/) {
                    proj = pgdata
                    sub(/\/\.postgres($|\/.*)/, "", proj)
                    printf "%-7s %s\n", $1, proj
                    found = 1
                  }
                  break
                }
              }
            }
            END { if (!found) print "(no devShell postgres running)" > "/dev/stderr" }
          '
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            jdk
            (pkgs.maven.override { jdk_headless = jdk; })
            postgresql
            pgInit
            pgStart
            pgStop
            pgStatus
            pgWhere
          ];

          env = {
            JAVA_HOME = "${jdk.home}";
          };

          shellHook = ''
            export PGDATA="$PWD/.postgres"
            export PGHOST="localhost"
            export PGPORT="5432"
            export PGUSER="''${DEVSHELL_PG_USER:-dev}"
            export PGDATABASE="''${DEVSHELL_PG_DATABASE:-dev}"
            export PGPASSWORD="''${DEVSHELL_PG_PASSWORD:-dev}"

            echo "devShell ready: java25 + maven + postgresql 18"
            echo "  pg-start  — first run will initdb; then start on 127.0.0.1:5432"
            echo "  pg-stop   — stop server"
            echo "  pg-status — show server status"
            echo "  pg-where  — show which directory each postmaster was started from"
            echo "  JDBC URL  : jdbc:postgresql://localhost:5432/$PGDATABASE  ($PGUSER / $PGPASSWORD)"
          '';
        };
      }
    );
}
