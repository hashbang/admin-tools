# Blocking a user

Sadly, sometimes abuse happen.
Sometimes, admins are required to block a user's account.
Sometimes, there is documentation explaining how.


## Setting their shell to `nologin`

On `ldap.hashbang.sh`:

	$ docker exec -i slapd ldapmodify -D "cn=admin,dc=hashbang,dc=sh" -w $ldap_password
	dn: uid=tty025,ou=People,dc=hashbang,dc=sh
	changetype: modify
	replace: loginShell
	loginShell: /usr/sbin/nologin


## Making sure the modification is taken into account

The `sss` daemon acts as a server-local cache for LDAP,
and you need to invalidate the cache (for that user only):

	ansible shell-servers -u root -a "sss_cache -u tty025"


## Terminating the user's processes

	ansible shell-servers -u root -a "loginctl terminate-user tty025"
