# How to block an account -- LDAP edition

Sadly, sometimes abuse happen.  
Sometimes, admins are required to block a user's account.  
Sometimes, there is automation for it.

	ansible-playbook ldap_ban.yml -e 'user=dude55b1'

The playbook will take care of disabling the account and
kicking the user from all shell servers.


# How the sausage is made

The playbook mainly performs two actions that can easily be done by hand:
- set the user's shell to `/usr/sbin/nologin` in LDAP;
- on each shell server:
  - invalidate the SSSd cache for that user;
  - terminate the user sessions.

The following details how to do it manually.


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


## Closing the user's sessions

Using Ansible:

	ansible shell_servers -u root -m shell -a "sss_cache -u dude55b1; loginctl terminate-user dude55b1"

This does two things, in order:
- invalidate that user's record in the SSS cache,
  otherwise the change in LDAP might not be picked up immediately;
- forcefully terminates the user's sessions (including all processes).

Unfortunately, `terminate-user` does not send a Russian mob
hitperson to dispatch the miscreant...
