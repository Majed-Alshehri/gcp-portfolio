## Phase 1: Real-Time Data Ingestion & CDC Pipeline

### Architecture Overview
- **Source Database:** GCP Cloud SQL (MySQL 8.0) deployed in `me-central2`.
- **Change Data Capture:** GCP Datastream streaming binary log events (`binlog_row_image=FULL`).
- **Data Landing Zone:** Google Cloud Storage (GCS) partitioned storage (`.jsonl.gz`).

### Implementation Details
1. **Source Configuration:** Enabled point-in-time recovery and set `log_bin_trust_function_creators=on` to allow deterministic function replication during schema migrations.
2. **Datastream Pipeline:** Configured binary log position tracking to automatically execute an initial full backfill across all 23 Sakila relational schemas followed by real-time change streaming.

### Verification & Test Evidence
- **Initial Load:** 1,000 baseline rows seeded and backfilled to GCS.
- **CDC Validation Payload:**

{
  "read_method": "mysql-cdc-binlog",
  "source_metadata": {
    "table": "actor",
    "change_type": "INSERT",
    "log_file": "mysql-bin.000003"
  },
  "payload": {
    "actor_id": 201,
    "first_name": "MAJED",
    "last_name": "DATAENGINEER"
  }
}
