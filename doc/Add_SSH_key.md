# Adding SSH keys for a user

**Note**: This is only for cases where, for some reason,
          `hashbangctl` is unavailable.
		  Otherwise, `sudo -E SUDO_USER=foo hashbangctl` works.

**Note**: Lines starting with `>` will be output from the command. Lines
starting with `<` will be what you input to the command. Lines starting
with `$` will be commands you run.

After using an SSH client to access `ldap.hashbang.sh`, run the following commands:

```sh
$ read ldap_password
< Input the password from `pass -c Hashbang/ldap_admin`; this will be copied to your clipboard.
$ docker exec -i slapd ldapmodify -D "cn=admin,dc=hashbang,dc=sh" -w $ldap_password << EOF
< dn: uid=<username>,ou=People,dc=hashbang,dc=sh
< changetype: modify
< add: sshPublicKey
< sshPublicKey: <SSH Public Key>
< EOF
$ exit
```

Next, check that logging in with the SSH key works.  Notify the user.

Note that this does not remove previously-existing SSH keys.
