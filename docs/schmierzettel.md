python3 -m venv .venv
source .venv/bin/activate

pip install -U pip
pip install -r requirements.txt

ansible-galaxy collection install -r requirements.yml
ansible-playbook -i inventories/testfeld/hosts.yml site.yml