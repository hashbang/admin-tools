# Installing packages on the shell servers

**NOTE**: This is a description of our current setup and of a possible
          workflow you can use.  This isn't *prescriptive*.


## `etckeeper` and `shell-etc`

The configuration present in the `/etc` directory of servers (with the
  exception of local configuration and secrets) is kept in the
  [`shell-etc`] repository.

This includes a `packages.txt` file, which is a list of all package
  selections.  That file is kept up-to-date using a post-install
  hook located in `etckeeper/post-install.d/00package-list`.

It should not be edited by hand, as it must contain all needed
  dependencies.  Moreover, packages installation (and upgrades) may
  modify `/etc`; as such, the most viable way to modify the package
  list is on a live server, using the usual `apt` commands, or on a
  local mockup (using Docker, for instance).

The current state of `/etc` in a shell server is always available in a
  private Gitolite instance: `git-infra.hashbang.sh`.  Each server has
  a branch on that remote, where only it can push (and cannot
  force-push).

[`shell-etc`]: https://github.com/hashbang/shell-etc


## Merging changes into `shell-etc`

Once an `apt` run is sucessfully completed, `etckeeper` commits the
result and pushes it to `git-infra.hashbang.sh`.

The simplest way to merge the change into `shell-etc` is to fetch it
from `git-infra` and perform a regular git merge:

	# Create the git-infra remote if you don't have it
	git remote add git-infra git-infra.hashbang.sh:shell-etc.git
	
	# Fetch the changes
	git fetch git-infra
	
	# Inspect the changes (here, coming form ny1.hashbang.sh)
	tig git-infra/ny1 # Use your favorite tool there
	
	# Perform the merge and publish
	git merge -S --no-ff git-infra/ny1
	git push


If the changes have been performed locally (for instance in a Docker
mockup), the procedure is similar, but the changes obviously do not
get pushed to `git-infra`.
