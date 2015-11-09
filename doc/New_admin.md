# Welcome!
Hi, dear new admin.

Thank you for chosing to dedicate time and energy to #!.  I hope we will learn
from one another and have fun  ;)

# Development process

_TODO:_ major/minor changes, provisor always major?

# Gaining access

## ... to the CoreOS servers
Send another admin your SSH public key(s);
they will add you to all CoreOS servers.

_TODO:_ Ansible automation for adding keys.

## ... to the shared password db
- Tell them your GitHub account name.  
  They will give you Git access to the shared pass db.
- Add yourself to the `.gpg-id` file, do a signed commit, push.
- The other admin confirms the key, then runs `pass init` to re-encrypt the
  files and pushes (again, signed commits!).

## ... to the shell servers
You now have access to `ldap.hashbang.sh`:
you can give yourself a password and add yourself to the `sudo` group.

### Password change

- SSH into `ldap.hashbang.sh`
- Invoke `unset HISTFILE` to avoid leaving the LDAP admin password in the history...
- Call `docker exec -i slapd ldappasswd -D "cn=admin,dc=hashbang,dc=sh" -w $FOO -S "uid=$USER,ou=People,dc=hashbang,dc=sh"`  
  Replace `$FOO` by the `ldap_admin` password, and `$USER` by your username.

### Adding a user to group `sudo`

Still on `ldap.hashbang.sh`, with `HISTFILE` unset:

	% docker exec -i slapd ldapmodify -D "cn=admin,dc=hashbang,dc=sh" -w $FOO
	dn: cn=sudo,ou=Group,dc=hashbang,dc=sh
	changetype: modify
	add: memberUid
	memberUid: $USER

_TODO:_ lrvick ought to review this part, since I didn't do it myself.

## ... to the DigitalOcean organisation
- Create a DigitalOcean account, in the #! organisation.  
  _NOTE:_ You **must** wait for the invitation mail, otherwise the account is
  created outside the team.

## ... to Dockerhub
- Create a DockerHub account, ask an admin for access.

## ... to IRC oper
Do this on both IRC servers (`sfo1.irc.hashbang.sh` and `lon1.irc.hashbang.sh`):

1. `unset HISTFILE`
2. Hash your password with `docker exec -it ircd Unreal3.2.10.4/unreal mkpasswd sha1 "$PASSWORD"`  
   _NOTE:_ It seems special characters can cause issues.
3. Run `vi unrealircd/opers.conf`
4. Insert your oper line:

		oper $USER {
		        class clients;
		        from { userhost *@*; };
		        password "$HASH" { sha1; }
		        flags { netadmin; can_gkline; can_override; can_gzline; can_restart; can_die; global; };
		};

5. `docker exec -it ircd Unreal3.2.10.4/unreal rehash`

Now, in your IRC client, you can `/oper $USER $PASSWORD`.
