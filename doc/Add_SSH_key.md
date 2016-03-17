# Adding SSH keys to a user

**Note**: This is only for cases where, for some reason,
          `hashbangctl` is unavailable.

**Note**: Lines starting with `>` will be output from the command. Lines
starting with `<` will be what you input to the command. Lines starting
with `$` will be commands you run.

After using an SSH client to access `ldap.hashbang.sh`, run the following commands:

```sh
$ read ldap_password
< Input the password from `pass -c Hashbang/ldap_admin`; this will be copied to your clipboard.
$ docker exec -i slapd ldapmodify -D "cn=admin,dc=hashbang,dc=sh" -w $ldap_password
< dn: uid=<username>,ou=People,dc=hashbang,dc=sh
< changetype: modify
< add: sshPublicKey
< sshPublicKey: <SSH Public Key>
< <EOF (ctrl-d for most systems)>
$ exit
```

Next, double-check to make sure the shell key works. Make sure to notify the user.
