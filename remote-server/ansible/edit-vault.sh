#! /bin/bash

PROJECT=teamcity

echo "Editing vault for... $PROJECT 🔌"

env EDITOR=nano ansible-vault edit "./group_vars/${PROJECT}.vault.yml"
