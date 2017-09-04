#!/usr/bin/env bash

# Global options
declare -a OPTIONS=( -x ANSIBLE0011 --exclude=roles/coreos-bootstrap )

# Per-file options
declare -A F_OPTIONS=(
    [shell.yml]="-x ANSIBLE0006"
    [ldap_ban.yml]="-x ANSIBLE0012"
)

if ! command -v ansible-lint >/dev/null; then
    echo "This script requires ansible-lint"
    exit 1
fi

set -ex

for playbook in *.yml; do
    ansible-lint "${OPTIONS[@]}" ${F_OPTIONS[$playbook]} $playbook
done
