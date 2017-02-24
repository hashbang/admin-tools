#!/usr/bin/env bash
set -e

KEY_FILE="vault_passphrase.pgp"
NEW_KEY_FILE=".vault_newpassphrase.pgp"

VAULT_FILES=( group_vars/all/vault.yml )
RECIPIENTS=(
    CDAB3CCDA649FFDA! # lrvick's 4k encryption key
    C91A9911192C187A  # daurnimator
    C60D4B85F1BAB95A  # ryan
    1D7C08C6CC263D74  # kellerfuchs
    26CDD32189AA2885  # dpflug
    78FC3358C2E3276E  # dgrove
)

if [ $# -eq 0 ]; then
    exec gpg --batch --decrypt "${KEY_FILE}" 2>/dev/null

elif [ $# -eq 1 ] && [ "$1" = "rekey" ]; then
    # Get 256b out of /dev/random, hex encoded
    NEW_KEY=$(od -vAn -N32 -tx -w /dev/random)

    # Save the new key
    gpg -e $(printf "%s" "${RECIPIENTS[@]/#/ -r }") -o "${NEW_KEY_FILE}" <<< "${NEW_KEY}"

    # Re-encrypt the files
    ansible-vault rekey --new-vault-password-file ./.vault_newpassphrase.sh "${VAULT_FILES[@]}"

    mv "${NEW_KEY_FILE}" "${KEY_FILE}"

else
    echo "$0:       Decrypt and output the vault key"
    echo "$0 rekey: Generate a fresh key and re-encrypt vault files"
    exit 1
fi
