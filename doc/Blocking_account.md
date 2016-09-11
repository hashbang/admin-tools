# How to block an account -- LDAP edition

Unfortunately, sometimes asshats don't take a hint and can't
be reasoned in using shared ressources respectfully.

For those times, the banhammer can be a reasonable option.


## Disabling the account

On `ldap.hashbang.sh`:

	% read ldap_password
	[LDAP admin password goes here]
	
	% docker exec -i slapd ldapmodify -D "cn=admin,dc=hashbang,dc=sh" -w $ldap_password
	dn: uid=dude55b1,ou=People,dc=hashbang,dc=sh
	changetype: modify
	replace: loginShell
	loginShell: /usr/sbin/nologin
	EOF


## Terminating the user

Using ansible:

	ansible shell_servers -u root -m shell -a "sss_cache -u dude55b1; loginctl terminate-user dude55b1"

This invalidates that user's record in the SSS cache, then forcefully
terminates the user's sessions (including all processes).

Unfortunately, `terminate-user` does not dispatch a Russian mob
hitperson to dispatch the miscreant...
