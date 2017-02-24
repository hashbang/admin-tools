#!/bin/sh

exec gpg --batch --decrypt ".vault_newpassphrase.pgp" 2>/dev/null
