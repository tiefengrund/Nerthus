# Architecture

Tactical Core Observability does not replace existing test automation.

Existing scripts and tools produce structured output, mainly JSON. This project ingests that output, normalizes it and makes it searchable and visible through dashboards.

## Purpose

Nerthus is an observability and analytics layer for structured test data.

The platform is intended to ingest, normalize and visualize artifacts produced during testing of tactical communication systems, including deployments based on Tactical Core.

It complements existing tooling by providing searchable data, dashboards and historical analysis without changing existing test workflows.

```mermaid
flowchart LR

subgraph Sources["Test / Data Sources"]
    PS["PowerShell scripts"]
    JSON["JSON reports"]
    PCAP["PCAP captures"]
    LOGS["System logs"]
end

subgraph Security["Local Security Layer"]
    CA["Local tactical CA"]
    CERTS["Self-signed service certificates"]
    VAULT["Ansible Vault"]
end

subgraph Runtime["Nerthus Host"]
    REG["Local Registry<br/>localhost:5000"]

    subgraph Podman["Podman network: tactical-net"]
        FILEBEAT["Filebeat"]
        PARSER["PCAP / JSON Parser"]
        LOGSTASH["Logstash"]
        ES["Elasticsearch"]
        KIBANA["Kibana"]
        GRAFANA["Grafana"]
    end
end

subgraph Clients["Clients / Access"]
    BROWSER["Web Browser"]
    API["API / Integrations"]
end

subgraph Offline["Air-Gap Artifacts"]
    IMAGES["Container image TARs"]
    RELEASES["Release metadata"]
    CONFIG["Static config"]
end

PS --> JSON
JSON --> FILEBEAT
PCAP --> PARSER
LOGS --> FILEBEAT

PARSER --> LOGSTASH
FILEBEAT --> LOGSTASH
LOGSTASH --> ES
ES --> KIBANA
ES --> GRAFANA

BROWSER --> KIBANA
BROWSER --> GRAFANA
API --> ES

CA --> CERTS
CERTS --> ES
CERTS --> KIBANA
CERTS --> GRAFANA
VAULT --> CA

IMAGES --> REG
REG -. supplies images .-> FILEBEAT
REG -. supplies images .-> PARSER
REG -. supplies images .-> LOGSTASH
REG -. supplies images .-> ES
REG -. supplies images .-> KIBANA
REG -. supplies images .-> GRAFANA
```

## Design principles

- Existing test logic stays untouched.
- Raw input data is preserved.
- Normalized data is derived from source data.
- The stack must work in air-gapped environments.
- Internet access is optional and only used during development or release preparation.

## Future Kubernetes Architecture

The current deployment targets a single observability host using Podman.

A future target architecture may run the stack on a Kubernetes cluster with approximately five nodes. This allows the platform to scale ingestion, storage and visualization workloads independently as data volume grows.

```mermaid
flowchart LR

subgraph Sources["Data Sources"]
    FB["Filebeat agents"]
    PCAP["PCAP / JSON feeds"]
end

subgraph K8S["Kubernetes Cluster"]
    LB1["LoadBalancer: Beats Ingest"]
    LB2["LoadBalancer: Web / API"]

    subgraph Ingest["Ingestion Layer"]
        LS1["Logstash Pod"]
        LS2["Logstash Pod"]
    end

    subgraph Storage["Elasticsearch Cluster"]
        M1["ES master-eligible"]
        M2["ES master-eligible"]
        M3["ES master-eligible"]
        D1["ES data"]
        D2["ES data"]
    end

    subgraph UI["Visualization Layer"]
        K1["Kibana Pod"]
        K2["Kibana Pod"]
        G1["Grafana Pod"]
        G2["Grafana Pod"]
    end

    PKI["Local PKI / TLS"]
end

FB --> LB1
PCAP --> LB1
LB1 --> LS1
LB1 --> LS2

LS1 --> D1
LS2 --> D2

D1 <--> D2
M1 <--> M2
M2 <--> M3

LB2 --> K1
LB2 --> K2
LB2 --> G1
LB2 --> G2

K1 --> D1
K2 --> D2
G1 --> D1
G2 --> D2

PKI -. certificates .-> LB1
PKI -. certificates .-> LB2
PKI -. certificates .-> Storage
```

## Scaling notes

Filebeat is expected to scale well against multiple Logstash endpoints when configured with `loadbalance: true`.

Logstash can be scaled horizontally for ingestion, but pipelines must be designed carefully. Stateful inputs, persistent queues and duplicate processing need to be considered.

Elasticsearch must not be treated as a simple stateless workload behind a generic load balancer. It requires explicit cluster design, persistent storage, shard allocation, replicas and master election resilience.

Kibana can be scaled behind a load balancer. It primarily depends on the Elasticsearch cluster and shared configuration.

The main reason for this future architecture is data growth. Once analysis becomes useful, the amount of collected data will increase naturally. The platform therefore needs a path from a single-node tactical deployment to a clustered deployment model.
