# Quick Start

thats basically how we spin this thing up

## Clone the repository

```bash
git clone url.git
cd nerthus
```

## Create the virtual environment

```bash
python3 -m venv .venv
source .venv/bin/activate
```

## Install Python dependencies

```bash
pip install -U pip
pip install -r requirements.txt
```

## Deploy

```bash
ansible-playbook \
  -i inventories/testfeld/hosts.yml \
  site.yml
```
