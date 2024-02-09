#! /bin/bash

set -e

ansible-playbook -e @group_vars/teamcity.vault.yml --vault-password-file .vault_passwd ./play-teamcity.yml -i ./hosts.ini
