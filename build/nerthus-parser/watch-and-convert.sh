#!/usr/bin/env bash

set -Eeuo pipefail

WATCH_DIR="/data/incoming-dbfs"
OUTPUT_DIR="/data/filebeat"
ARCHIVE_DIR="/data/archive"

mkdir -p "$OUTPUT_DIR" "$ARCHIVE_DIR"

inotifywait \
  --monitor \
  --event close_write,moved_to \
  --format '%w%f' \
  "$WATCH_DIR" |
while IFS= read -r source_file; do
    case "${source_file,,}" in
        *.dbf)
            filename="$(basename "$source_file")"
            stem="${filename%.*}"

            tmp_file="${OUTPUT_DIR}/.${stem}.geojson.tmp"
            output_file="${OUTPUT_DIR}/${stem}.geojson"

            python3 /app/dbf_to_geojson.py \
                "$source_file" \
                "$tmp_file"

            # Filebeat sieht nur die vollständig geschriebene Datei.
            mv "$tmp_file" "$output_file"

            mv "$source_file" \
               "${ARCHIVE_DIR}/${filename}"
            ;;
    esac
done
