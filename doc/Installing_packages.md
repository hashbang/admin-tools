# Installing packages on the shell servers

**NOTE**: This is a description of our current setup and of a possible workflow
          you can use.  This isn't *prescriptive*.

## `etckeeper` and `shell-etc`

The configuration present in the `/etc` directory of servers (with the exception
  of local configuration and secrets) is kept in the [`shell-etc`] repository.

This includes a `packages.txt` file, which is a list of all package selections.
That file is kept up-to-date using a post-install `etckeeper` hook located in
  `etckeeper/post-install.d/00package-list`.

It should not be edited by hand, as it must contain all needed dependencies.
Moreover, packages installation (and upgrades) may modify `/etc`;  as such, the
  most viable way to modify the package list is on a live server, using the
  usual `apt` commands.

[`shell-etc`]: https://github.com/hashbang/shell-etc


## Pushing changes to `shell-etc`

Once an `apt` run is sucessfully completed, `etckeeper` commits the result and
  attempts to push it to [`shell-etc`].

The simplest way to do so is to have an SSH agent running (as your user, not as
  `root`), with a SSH key loaded that can push to [`shell-etc`].  Note that the
  key doesn't need to be on the server, SSH Agent forwarding and
  [`ssh-agent-filter`] can be used to keep it safely client-side if desired.

Indeed, when running a command using `sudo`, the `${SSH_AUTH_SOCK}` environment
  variable is preserved, letting `ssh` use your personal `ssh-agent`.

[`ssh-agent-filter`]: https://github.com/tiwe-de/ssh-agent-filter
