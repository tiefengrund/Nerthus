#!/usr/bin/env python3
import json
from pathlib import Path
from collections import Counter, defaultdict

base = Path("/srv/tactical/captures/incoming")

attr_types = defaultdict(Counter)
top_keys = Counter()
report_count = 0
file_count = 0

for path in sorted(base.glob("Test-Report*.json")):
    file_count += 1
    data = json.loads(path.read_text(encoding="utf-8-sig"))

    reports = data.get("testReport", [])
    report_count += len(reports)

    for report in reports:
        for key in report.keys():
            top_keys[key] += 1

        for attr in report.get("testCaseAttributes", []):
            name = attr.get("name", "<missing>")
            value = attr.get("value")
            attr_types[name][type(value).__name__] += 1

print(f"files:   {file_count}")
print(f"reports: {report_count}")

print("\nTop-level report keys:")
for key, count in top_keys.most_common():
    print(f"{key:30} {count}")

print("\nAttribute value types:")
for name in sorted(attr_types):
    types = ", ".join(f"{t}:{c}" for t, c in attr_types[name].items())
    print(f"{name:30} {types}")