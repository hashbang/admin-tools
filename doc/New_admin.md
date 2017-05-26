# Welcome!

Hi, dear new admin.

Thank you for chosing to dedicate time and energy to #!.  I hope we will
  learn from one another and have fun  ;)


# Development process

_TODO:_ major/minor changes, provisor always major?


# Gaining access -- part I

We will first go over the parts that require cooperation
  with an established admin.


## ... to the shared password db

- Tell them your Github account name.  
  They will give you Git access to the Github org, including the shared
  pass db.
- Add yourself to the `.gpg-id` file, do a signed commit, push.
- The other admin confirms the key, then runs `pass init` to re-encrypt
  the files and pushes (again, signed commits!).


## ... to the Ansible Vault

The other admin must also reencrypt the Ansible Vault,
now that they know your GPG key:

1. Add the key, by fingerprint, to the `RECIPIENTS` array
   in `vault_passphrase.sh`.

2. Run `vault_passphrase.sh rekey`.  This generates a fresh
   vault keys, re-encrypts the vault files and encrypts the
   new key using GPG.

3. Commit `vault_passphrase.pgp` and the vault files.
   Push.


While this goes on, setup [git configuration] to deal with GPG
and Ansible Vault files.  You can confirm it works properly by
reviewing pull requests to this repository.

[git configuration]: https://github.com/hashbang/admin-tools#git-configuration


## ... to the CoreOS servers & IRC oper

Add your SSH keys in this repository:
- Edit `group_vars/all/users.yml` and add a user object with your nick
  in `users`.  The expected values are documented in the file.  
  Be careful and do not put secrets (including password hashes) in plain
  text there, that's what Ansible Vault is for.
- Do a signed commit and create a pull request.
- Ask an admin to review, run `credentials.yml` and merge.


### Certificate authentication

The preferred way to authenticate as an IRC oper is by using a SSL
client certificate, which WeeChat supports fairly easily:

1. Generate the certificate

		mkdir ~/.weechat/ssl
		cd ~/.weechat/ssl
		openssl req -nodes -newkey rsa:2048 -keyout kellerfuchs.key -x509 -days 3650 -out kellerfuchs.crt
		cat kellerfuchs.{crt,key} > kellerfuchs.pem
		rm  kellerfuchs.{crt,key}

2. Get its key fingerprint

		openssl x509 -noout -fingerprint -sha256 -in kellerfuchs.pem

3. Set it as your authentication method in `groups_var/all/users.yml`:

		kellerfuchs:
		  irc_oper:
		    type: sslclientcertfp
		    pass: "0A:D8:51:3B:C6:1A:AB:6C:78:17:56:14:0A:D9:5E:43:4A:D9:33:64:04:5D:7F:4D:45:57:C2:86:33:D5:62:5B"

4. Configure weechat to use it:

		/set irc.server.hashbang.ssl_cert %h/ssl/kellerfuchs.pem

5. Test it:

		/reconnect hashbang
		/oper kellerfuchs x


_NOTE:_ Of course, use your own username everywhere,
        rather than kellerfuchs...


## ... to the DigitalOcean organisation

- Create a DigitalOcean account, in the #! organisation.  
  _NOTE:_ You **must** wait for the invitation mail, otherwise the
  account is created outside the team.


## ... to Dockerhub

- Create a DockerHub account, ask an admin for access.


# Gaining access -- part II

By now, you have all you need to add yourself the missing access.
Take it as an opportunity to familiarise yourself with our
  infrastructure, and don't hesitate to ask questions to other admins.


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


### Adding a user to the `team@` distribution list

1. Check that your email in `group_vars/all/users.yml` is correct.  
   It can point to the vault `mail: {{ vault_users.$USER.mail }}` and
   defaults to `$USER@hashbang.sh`.
2. Run the `mail.yml` playbook.
