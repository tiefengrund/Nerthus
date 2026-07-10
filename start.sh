#!/usr/bin/env bash


python3 -m venv .venv
# shellcheck source=/dev/null
source .venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml

ansible-playbook -i inventories/testfeld/hosts.yml site.yml
