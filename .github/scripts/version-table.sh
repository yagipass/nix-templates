version_rows() {
  jq -rn --arg label "$1" --argjson before "$2" --argjson after "$3" '
    ($before | map({(.name): .version}) | add // {}) as $old
    | $after[]
    | select($old[.name] != .version)
    | "| \($label) | \(.name) | `\($old[.name] // "N/A")` | `\(.version)` |"
  '
}

version_body() {
  echo "$1"
  echo
  echo "## Package Versions"
  echo
  if [ -z "$2" ]; then
    echo "Flake inputs were updated, but no package version changed."
  else
    echo "| Flake | Package | Old | New |"
    echo "|-------|---------|-----|-----|"
    printf '%s\n' "$2"
  fi
}
