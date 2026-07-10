# Reset

This document describes how to reset the local Nerthus stack during development.

The reset removes processed Filebeat state, restarts ingestion containers and clears Elasticsearch indices.

## Why is a reset required?

Nerthus is designed as a platform for ingesting and analyzing continuously generated operational data.

In production environments, data continuously flows from tactical systems into the observability stack. Dashboards, metrics and historical trends evolve naturally as new data arrives.

During development, however, no live tactical environment is available. Instead, static JSON reports and recorded PCAP captures are replayed repeatedly to validate parsers, ingestion pipelines and dashboards.

Filebeat correctly remembers which files have already been processed, Elasticsearch already contains indexed documents and Logstash pipelines may still hold state from previous development runs. Replaying the same dataset therefore requires resetting the development environment.

The reset procedure intentionally clears this state so identical datasets can be ingested again and produce reproducible results.

---

The long-term objective is significantly more ambitious.

Nerthus is intended to become a unified observability platform for tactical communication systems. Instead of visualizing isolated test reports, the platform should correlate multiple telemetry sources, including:

- structured test reports
- network captures (PCAP)
- application logs
- infrastructure metrics
- vehicle position and movement
- timing information
- environmental conditions such as terrain and weather

Correlating these independent data sources enables engineers to investigate complex problems that cannot be identified from individual log files alone.

The reset mechanism described in this document exists purely to support development until continuous live data becomes available.

> Warning: This deletes indexed data from Elasticsearch.

## Manual reset

Allow wildcard index deletion in Elasticsearch:

```bash
curl -X PUT "http://localhost:9200/_cluster/settings" \
  -H "Content-Type: application/json" \
  -d '{
    "persistent": {
      "action.destructive_requires_name": false
    }
  }'
```

Delete all indices:

```bash
curl -X DELETE "http://localhost:9200/*"
```

Remove processed Filebeat state:

```bash
rm -rf /opt/tactical/filebeat/data/*
```

Remove ingestion containers:

```bash
podman rm -f tactical-filebeat tactical-logstash
```

Redeploy the stack:

```bash
ansible-playbook \
  -i inventories/testfeld/hosts.yml \
  site.yml
```

## Shortcut

Use the reset playbook:

```bash
ansible-playbook \
  -i inventories/testfeld/hosts.yml \
  playbooks/reset.yml
ansible-playbook \
  -i inventories/testfeld/hosts.yml \
  site.yml
```
