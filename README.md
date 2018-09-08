# #! Admin Tools

Ansible playbooks and other admin tools/docs for maintaining the #! network.


## Requirements

  * Recent version of Ansible
  * Local [#! pass database](https://github.com/hashbang/password-store)
  * User with sudo access on all servers


### Git configuration

You might also want to use the following snippet in `~/.gitconfig`:

	[diff "gpg"]
		textconv = gpg --no-tty --decrypt
		cachetextconv = false
	[diff "ansible-vault"]
		textconv = ansible-vault view
		cachetextconv = false


### SSH configuration

All the “service servers” (as opposed to shell servers) listen for SSH
on port 8993 (ASCII-encoding of `#!`), and the user is `core`, with
the following exceptions:
- `lon1.irc.hashbang.sh` and `sfo1.irc.hashbang.sh`
  do not yet follow that convention;
- `git-infra.hashbang.sh` is a service hosted on `nyc3.apps.hashbang.sh`
  which uses port 22.

This is expressed in the following `.ssh/config` snippet:

	Host da1.hashbang.sh ny1.hashbang.sh sf1.hashbang.sh to1.hashbang.sh
	     User your_nick

	Host git-infra.hashbang.sh
	     User git

	Host sfo1.irc.hashbang.sh ldap.hashbang.sh
	     User core

	Host *.hashbang.sh hashbang.sh
	     User core
	     Port 8993


## Playbooks

There are several playbooks present here:
- `shell.yml` is used to synchronise the configuration (incl. installed packages)
  across the shell servers.
- `credentials.yml` is used to deploy the admin's SSH keys across all servers:
  - admins can login as `root` on the shell servers;
  - they can login as `core` on the CoreOS servers.
- `coreos.yml` performs CoreOS-specific tasks.  Currently, it only bootstraps
  the Ansible agent's dependencies.
- `mail.yml` deploy the mail aliases and Postfix configuration.
- `irc.yml` deploys static and templated configuration to the IRC servers,
  including oper blocks for users defined in `group_vars/all/users.yml`.
- `ldap_ban.yml` disables user accounts in LDAP and terminates their
  sessions on the shell servers; it requires python-ldap installed.
  Invoke as follows:

		ansible-playbook ldap_ban.yml -e 'users=${USERNAME}'

  `users` can be a comma-separated list of users.


## Usage

### Install a package

See `doc/Installing_packages.md`.


### Making a configuration change

 1. Prepare your change for `shell-etc`, test it locally.
 2. Create a pull-request for it on Github, wait for a review.
 3. Perform a **signed** merge into `master`: `git merge -S --no-ff branch`  
	Only merge into `master` things that you will deploy immediately.
	Do not merge if you aren't in a position to follow-up with a deploy.
 4. Run the `shell.yml` playbook, see below.


### Sync packages & configuration across all shell servers

Simply run the appropriate Ansible playbook:
```bash
ansible-playbook shell.yml
```
