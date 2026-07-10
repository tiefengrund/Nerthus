# Contributing

Thank you for contributing to Nerthus.

This document describes the minimum requirements for contributing to the project. The goal is to maintain a consistent, secure and production-ready codebase.

---

# Development environment

Create and activate a Python virtual environment before working on the project.

```bash
python3 -m venv .venv
source .venv/bin/activate

pip install -U pip
pip install -r requirements.txt
```

---

# Repository structure

The project is organized into independent Ansible roles.

Each role should have a single responsibility.

Typical layout:

```
roles/
    prep/
    local_registry/
    image_loader/
    elastic_stack/
    grafana/
    healthchecks/
```

New functionality should be implemented inside a dedicated role whenever possible.

---

# Coding guidelines

- Prefer idempotent Ansible tasks.
- Use Fully Qualified Collection Names (FQCN).
- Keep tasks focused and easy to review.
- Store configurable values in `defaults/main.yml`.
- Document newly introduced variables.
- Prefer readability over clever implementations.
- Design features to work in air-gapped environments whenever possible.

---

# Documentation

Documentation is part of the implementation.

When introducing new functionality, update the corresponding documentation inside the `docs/` directory.

Architecture changes should also update the architecture documentation.

---

# Commit messages

Use descriptive commit messages.

Examples:

```
feat(image_loader): check upstream releases
fix(filebeat): correct parser path
docs: add deployment documentation
refactor(prep): simplify package installation
chore: normalize YAML formatting
```

Avoid generic commit messages such as:

```
fix
update
stuff
asdf
```

---

# Git workflow

The `master` branch is protected.

Direct commits to `master` are not permitted.

All changes must be submitted through a Merge Request.

Every Merge Request must:

- pass the CI pipeline,
- receive at least one approval,
- follow the four-eyes principle before being merged.

---

# Code quality

All code must pass the project's quality gates.

Typical checks include:

- yamllint
- ansible-lint
- markdownlint

The CI pipeline is considered the authoritative validation.

---

# Security

This project targets tactical and disconnected environments.

Please consider the following during development:

- Internet connectivity is optional.
- Air-gapped deployments must continue to work.
- Do not introduce unnecessary online dependencies.
- Do not commit credentials, certificates or private keys.
- Sensitive information must never be stored in the repository.

---

# Questions

When in doubt, discuss architectural or security relevant changes before implementation.

Small pull requests are preferred over large, unrelated changes.
