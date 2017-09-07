# Ansible Vault

This directory contains encrypted configuration data used by Ansible.

The encryption is done against a passphrase, stored itself in
`passphrase.pgp`.  Using `passphrase.sh rekey`generates a new passphrase,
decrypts all files and reencrypt them against the new passphrase.

## Using Vault

### Inside a playbook

Each bundle of data is kept in a separate directory, and can be loaded
in a playbook using `include: vault.yml load=<name>`.

### Editing Vault data

From the `admin-tools` directory, you can use the `ansible-vault` tool to edit
Vault-encrypted files; for instance, `ansible-vault edit vault/irc/vault.yml`.

**Important:** Always use `ansible-vault edit` to edit encrypted files.
               Using `decrypt`/`encrypt` leaves unencrypted data on the disk,
               and you risk commiting plaintext data if you forget to `encrypt`.


## Best practices

- Make an unencrypted file, that defines the structure of the data,
  and refers to encrypted variables for secrets.  For instance:
  
		users:
		  deviavir:
		    key: https://github.com/deviavir.keys
		    github: deviavir
		    irc_oper:
		      type: sslclientcertfp
		      pass: "BE:D2:60:10:04:57:93:A3:EF:AC:[...]"
		    mail: "{{ vault_users.deviavir.mail }}"

  This is recommended because there is a plaintext (i.e. grep-able and
  readable by non-admins) documentation of which data is where.
  
  See also <https://docs.ansible.com/ansible/latest/playbooks_best_practices.html#variables-and-vaults>

- Make a single object in the unencrypted file, named after the directory, and
  a single object in the encrypted file, with `vault_` prepended to the name.
  
  This was, when seeing `irc.spam_filters`, it is easy to know it comes from
  `vault/irc`, and same thing for `vault_irc.spam_filters`.

- Call the encrypted data-file `vault.yml`, so our tools (Git and the rekeying
  script) automatically recognise the file as encrypted.
