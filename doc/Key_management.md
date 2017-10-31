# Key management for #! admins

There are a couple of places where public key material
is stored and must be kept up-to-date:

- `files/keys/${name}.pub` must contain your SSH public key for #!
  administration; it is used for root access to shell servers and CoreOS boxes.
- `/var/lib/hashbang/admins.gpg` contains, on the shell servers, a GPG keyring
  used to authenticate the [`dotfiles`] and [`shell-etc`] repositories.
- [`.gpg-id`], in the [`password-store`] repository, contains a list
  of key fingerprints against which secrets are encrypted.


[`dotfiles`]:       https://github.com/hashbang/dotfiles
[`shell-etc`]:      https://github.com/hashbang/shell-etc
[`password-store`]: https://github.com/hashbang/password-store
[`.gpg-id`]:        https://github.com/hashbang/password-store/blob/master/.gpg-id


## SSH public key

Nothing much to say there: put the pubkey file in the right
directory, do a signed commit, send the PR.


## OpenPGP public key

OpenPGP keys, unlike SSH ones, don't simply include a public signing key,
but also metadata, like expiration times and UID, and signatures certifying
other keys and subkeys.  Care must be taken every time those change.


### Your local keyring

Many aspects of #!, especially verifying updates to repositories when you
pull them, require you to:
1. be able to trust the authenticity of your fellow admins' keys;
2. have an up-to-date copy of said keys.

For (1), we strive to maintain a dense network of cross-signatures between
admins, making it easier for you to check all keys if you know a few admins'
keys.
This also means you should only sign keys whose authenticity you checked  ;)

The simplest way to achieve (2) is to run `gpg --recv-keys` in a cronjob
(or system timer, or whatever...), but this leaks to the keyserver the
contents of your keyring (i.e., who you communicate with using OpenPGP).

Instead, the recommended way of doing this is to use [`parcimonie`],
a tool which will only fetch updates one key at a time, periodically,
and over Tor.

[`parcimonie`]: https://gaffer.ptitcanardnoir.org/intrigeri/code/parcimonie/


### On the shell servers

`/var/lib/hashbang/admins.gpg` is maintained by a cronjob which can be found
in [`/etc/cron.daily/gpg-keyring`], and updated daily from key servers.

The script contains a list of key fingerprints, as a Bash array, and so only
needs updating whenever your primary key changes; the procedure for that is
the usual for `shell-etc`: commit, pull request, signed merge, and run
`shell.yml`.  However, because the deploy scripts rely on that keyring to
authenticate the contents of `shell-etc`, you will likely need someone else
to perform the signed merge.

`shell.yml` will take care to automatically rerun `gpg-keyring` after
deploying a `shell-etc` change, so your key will be useable immediately.


[`/etc/cron.daily/gpg-keyring`]: https://github.com/hashbang/shell-etc/blob/master/cron.daily/gpg-keyring


### In the password store

`pass` uses, by default, 64 bits key ids, rather than full 160 bit
OpenPGP fingerprints.

[`.gpg-id`] contains those ids, one per line.  It is possible to specify
a specific decryption subkey, by using that subkey's id, suffixed with `!`.
Otherwise, GnuPG will default to the most recent, valid, decryption subkey.

After changing this file, run the following in your `password-store`
checkout to re-encrypt the secrets to the new recipients:

    $ xargs gpg --recv-keys < .gpg-id  # If your keyring is outdated
    $ export PASSWORD_STORE_DIR="${PWD}"
    $ xargs pass init < .gpg-id
    $ unset PASSWORD_STORE_DIR
