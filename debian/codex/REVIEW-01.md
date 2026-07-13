# Task 1 v2 read-only review

Review the current Task 1 v2 branch without editing files. Inspect the exact
35-patch series, DEP-3 metadata, current versus superseded SHAs, logical split,
generated-configure exclusion, upstream-tree equality, unapplied source base,
all four build profiles, verifier evidence, `.work/` tracking, and unchanged
Maintainer/adopter stance.

Separate findings into Artifact findings and Procedure findings. Every
unresolved Critical, High, Medium, or Low finding makes that category FAIL.
Non-actionable observations belong under Notes.

The final three non-empty lines must be exactly:

TASK1 ARTIFACT RESULT: PASS|FAIL — Critical=N High=N Medium=N Low=N
TASK1 PROCEDURE RESULT: PASS|FAIL — Critical=N High=N Medium=N Low=N
FINAL RESULT: PASS|FAIL

FINAL PASS is allowed only when both category lines are PASS with all counts zero.
