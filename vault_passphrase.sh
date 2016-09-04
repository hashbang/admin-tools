#!/bin/sh
exec gpg --batch --decrypt vault_passphrase.pgp 2>/dev/null
