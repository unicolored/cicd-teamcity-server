# CI/CD withTeamcity

Setup a private host with Ansible, to run Teamcity server and agents.

Start a Teamcity agent locally and connect it to the server. \
https://hub.docker.com/r/jetbrains/teamcity-agent/

A PostGres database is required for the Teamcity server.

## Prerequisites

- Configure the hosts.ini file with the hostname and ip of the server.
- Add you aws credentials in both agent and server if needed
- Add an ssh key to the agent if needed
- Update the ansible vault variables: remote-server/ansible/group_vars/teamcity.vars.yml
- Add public and private cert for https on the nginx proxy
