# Task 2 v2 failure triage — read only

Analyze supplied local verifier or Actions failure without editing files.
Classify the first root cause as UPSTREAM_SOURCE, TASK1_PATCHSET,
TASK2_PACKAGING, CI_INFRASTRUCTURE, or INCONCLUSIVE. State exact command,
file, diagnostic, and owner phase. Never recommend changing upstream source or
quilt patches inside Task 2.

The final line must be exactly:
FAILURE CLASSIFICATION: UPSTREAM_SOURCE|TASK1_PATCHSET|TASK2_PACKAGING|CI_INFRASTRUCTURE|INCONCLUSIVE
