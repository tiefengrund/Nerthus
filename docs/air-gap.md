# Air-Gap Mode

Nerthus is designed to operate in disconnected environments.

Once the system reaches an air-gapped state, there is no way to call home. The deployment must rely only on the artifacts, container images, configuration and documentation that were prepared beforehand.

## Purpose

Air-gap mode allows classified or sensitive tactical data to be monitored, normalized and analyzed without requiring external connectivity.

No component should depend on Internet access during operation.

## Data handling

Before any system is allowed to reconnect to external networks, the observability stack must be [reset](reset.md) and all sensitive data must be removed or rendered unusable.

Until a dedicated scrambling routine exists, sensitive datasets should be treated as non-exportable.

A future implementation may provide controlled data scrambling for development and debugging purposes. Until then, encrypted data with automatically destroyed keys is the safer interim approach.

## Rules

- Do not call home from classified or sensitive environments.
- Do not upload operational data.
- Do not reconnect before reset.
- Do not export raw data.
- Only use prepared offline artifacts.
- Treat all indexed data as sensitive.
