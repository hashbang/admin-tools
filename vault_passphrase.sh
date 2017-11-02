#!/usr/bin/env bash
set -e

KEY_FILE="vault_passphrase.pgp"
NEW_KEY_FILE=".vault_newpassphrase.pgp"

VAULT_FILES=(
    vault/*/vault.yml
)
RECIPIENTS=(
    0x54BA90995CCBD6D6B0E68D27CDAB3CCDA649FFDA! # lrvick's 4k encryption key
    0x954A3772D62EF90E4B31FBC6C91A9911192C187A  # daurnimator
    0x47BF2F123A4F98EF279DC3DFC60D4B85F1BAB95A  # ryan
    0x1E45FC4E01DB58D5E89F10F0DE22C727EA42F001  # kellerfuchs
    0xF2B7999666D83093F8D4212926CDD32189AA2885  # dpflug
    0xC92FE5A3FBD58DD3EC5AA26BB10116B8193F2DBD  # drGrove
    0x0A1F87C7936EB2461C6A9D9BAD9970F98EB884FD  # DeviaVir
    0x3D7C8D39E8C4DF771583D3F0A8A091FD346001CA  # singlerider
)

if [ $# -eq 0 ]; then
    exec gpg --decrypt --quiet "${KEY_FILE}"

elif [ $# -eq 1 ] && [ "$1" = "rekey" ]; then
    # Get 256b out of /dev/urandom, hex encoded
    NEW_KEY=$(od -vAn -N32 -tx -w /dev/urandom)

    # Save the new key
    # Using `--trust-model always` is valid: key are designated by fingerprint
    gpg --trust-model always                        \
        -e $(printf "%s" "${RECIPIENTS[@]/#/ -r }") \
        -o "${NEW_KEY_FILE}" <<< "${NEW_KEY}"

    # Re-encrypt the files
    ansible-vault rekey --new-vault-password-file ./.vault_newpassphrase.sh "${VAULT_FILES[@]}"

    mv "${NEW_KEY_FILE}" "${KEY_FILE}"

else
    echo "$0:       Decrypt and output the vault key"
    echo "$0 rekey: Generate a fresh key and re-encrypt vault files"
    exit 1
fi
