# Task 1 v2 failure triage — read only

Analyze supplied logs without editing files. Classify the first root cause as
one of: UPSTREAM_REFERENCE, TASK1_PATCHSET, WORKBOOK_PROCEDURE, ENVIRONMENT,
INCONCLUSIVE. State the exact failing command/file/diagnostic and owner phase.
Do not propose weakening the build matrix or patch policy.

The final line must be exactly:
FAILURE CLASSIFICATION: UPSTREAM_REFERENCE|TASK1_PATCHSET|WORKBOOK_PROCEDURE|ENVIRONMENT|INCONCLUSIVE
