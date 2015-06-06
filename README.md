# #! Admin Tools

Ansible playbooks and other admin tools/docs for maintaining the #! network.

## Requirements

  * Recent version of Ansible
  * Local [#! pass database](https://github.com/hashbang/password-store)
  * User with sudo access on all servers

## Usage

  ### Install a package

  1. Connect to any shell server as yourself

      ```bash
      ssh you@ny1.hashbang.sh
      ```

  2. Install Package

      ```bash
      sudo apt-get install some-package
      ```

  3. Update packages.txt list

      ```bash
      sudo dpkg --get-selections > /etc/packages.txt
      ```

  3. Commit changes via etckeeper

      ```bash
      sudo etckeeper commit -m 'Updated some package'
      ```

  ### Making a configuration change

  1. Connect to any shell server as yourself

      ```bash
      ssh you@ny1.hashbang.sh
      ```

  2. Make and test any desired changes to files in /etc

      ```bash
      sudo vim /etc/some-config/file
      ```

  3. Commit changes via etckeeper

      ```bash
      sudo etckeeper commit -m 'updated some-config with some change'
      ```

  ### Sync packages/config across all servers

  1. Run Ansible playbook "sync"

      ```bash
     ansible-playbook -K -u your-sudo-user sync.yml
      ```
