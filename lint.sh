#!/usr/bin/env bash

set -e

# Global options
declare -a OPTIONS=( --exclude=roles/coreos-bootstrap )
declare -a IGNORES=( ANSIBLE0011 )

# Per-file lint ignores
declare -A F_IGNORES=(
    [shell.yml]="ANSIBLE0006"
    [ldap_ban.yml]="ANSIBLE0012"
)

function exec() {
    echo '$' "$@"
    "$@"
}

function join {
    local IFS="$1"
    shift
    echo "$*"
}

if ! command -v ansible-lint >/dev/null; then
    echo "This script requires ansible-lint"
    exit 1
fi

for playbook in *.yml; do
    exec ansible-lint "${OPTIONS[@]}"                         \
         -x "$(join , ${IGNORES[@]} ${F_IGNORES[$playbook]})" \
         $playbook
done
