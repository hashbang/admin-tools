#!/bin/sh

exec gpg --quiet --decrypt ".vault_newpassphrase.pgp"
