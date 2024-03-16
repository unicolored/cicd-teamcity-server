#! /bin/bash

set -e

ansible-playbook -e @group_vars/vault.yml --vault-password-file .vault_passwd ./play.yml -i ./hosts.ini
