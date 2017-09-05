#!/usr/bin/env bash

set -e

# Global options
declare -a OPTIONS=( -x ANSIBLE0011 --exclude=roles/coreos-bootstrap )

# Per-file options
declare -A F_OPTIONS=(
    [shell.yml]="-x ANSIBLE0006"
    [ldap_ban.yml]="-x ANSIBLE0012"
)

exec() {
    echo '$' "$@"
    "$@"
}


if ! command -v ansible-lint >/dev/null; then
    echo "This script requires ansible-lint"
    exit 1
fi

for playbook in *.yml; do
    exec ansible-lint "${OPTIONS[@]}" ${F_OPTIONS[$playbook]} $playbook
done
