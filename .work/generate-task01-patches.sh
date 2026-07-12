#!/bin/sh
set -eu

P=debian/patches
DATE=2026-07-12

emit_header() {
  file=$1 desc=$2 commits=$3 forwarded=$4
  {
    printf 'Description: %s\n' "$desc"
    printf ' Source commits: %s\n' "$commits"
    printf 'Origin: upstream\n'
    printf 'Forwarded: %s\n' "$forwarded"
    printf 'Last-Update: %s\n\n' "$DATE"
  } > "$P/$file"
}

append_commit() {
  file=$1 commit=$2
  shift 2
  git diff --no-ext-diff --binary "$commit^" "$commit" -- "$@" >> "$P/$file"
}

direct() {
  file=$1 desc=$2 commit=$3
  shift 3
  emit_header "$file" "$desc" "$commit" yes
  append_commit "$file" "$commit" "$@"
}

rm -f "$P"/*

direct 0001-configure-check-standard-headers.patch \
  'Check for standard C library headers in configure.' \
  adefb67746514c2cf16fa19e41275d29e7b280bf configure.in
direct 0002-configure-fix-termcap-tests.patch \
  'Make the termcap and terminfo configure tests valid under C23.' \
  73f4f2d54f7894f7448f10907392f0ee2b146110 configure.in
direct 0003-configure-fix-libwrap-test.patch \
  'Include the libwrap declarations in its configure test.' \
  d624813b2210db7e7b66688154a3911539809db5 configure.in
direct 0004-configure-use-default-source.patch \
  'Use _DEFAULT_SOURCE for current glibc feature declarations.' \
  b8c95ad64da5de58857c72f4b3644d90c6e6e53c configure.in
direct 0005-build-dictionaries-in-C-locale.patch \
  'Run dictionary text filtering in the C locale.' \
  1195a7660cd0ff31dbe0daec09210338126fa1bf \
  Wnn/pubdicplus/Makefile.in cWnn/cdic/Makefile.in cWnn/tdic/Makefile.in kWnn/kdic/Makefile.in

emit_header 0010-use-system-libc-declarations.patch \
  'Use system headers for standard C library declarations.' \
  'b90513011520dbe4b34816b0aad62275d0815fbb; d582d0ea7dfd937d56f911ee5e1695d45dcc9288' yes
append_commit 0010-use-system-libc-declarations.patch b90513011520dbe4b34816b0aad62275d0815fbb \
  Wnn/jlib.V3/jlv3.c Wnn/jlib/jl.c Wnn/jlib/js.c Wnn/jutil/wddel.c Wnn/jutil/wdreg.c \
  Wnn/jutil/wnnstat.c Wnn/uum/termcap.c Wnn/uum/wnnrc_op.c
append_commit 0010-use-system-libc-declarations.patch d582d0ea7dfd937d56f911ee5e1695d45dcc9288 Wnn/etc/pwd.c

emit_header 0011-fix-bundled-getopt-declarations.patch \
  'Use valid declarations and system headers in bundled getopt.' \
  'b59c2fc9bf5d301c8dce484f637ec506ac36fb7c; 17578cf34877cad67c465335afbf499b88cecce1' yes
append_commit 0011-fix-bundled-getopt-declarations.patch b59c2fc9bf5d301c8dce484f637ec506ac36fb7c Wnn/include/getopt.h
append_commit 0011-fix-bundled-getopt-declarations.patch 17578cf34877cad67c465335afbf499b88cecce1 Wnn/etc/getopt.c

emit_header 0012-remove-redundant-project-declarations.patch \
  'Remove redundant old-style declarations from function bodies.' \
  '13d0d075a91eebf18e16615a732abcaae2b349b0; 17578cf34877cad67c465335afbf499b88cecce1; 9618769b8e758f537db180a9389c7ce10c536163' yes
append_commit 0012-remove-redundant-project-declarations.patch 13d0d075a91eebf18e16615a732abcaae2b349b0 Wnn/jutil/atorev.c
append_commit 0012-remove-redundant-project-declarations.patch 17578cf34877cad67c465335afbf499b88cecce1 Wnn/etc/bdic.c
append_commit 0012-remove-redundant-project-declarations.patch 9618769b8e758f537db180a9389c7ce10c536163 Wnn/jserver/daibn_kai.c

emit_header 0020-fix-sort-callback-interface.patch \
  'Give the internal sorting interface const-correct callback types.' \
  'a85b88729c2fa7d0a2ec542d737c5e19061c8a47; 915ecd5efe7a9ab09fc073c8131687184a45dfa4' yes
append_commit 0020-fix-sort-callback-interface.patch a85b88729c2fa7d0a2ec542d737c5e19061c8a47 Wnn/include/jutil.h
append_commit 0020-fix-sort-callback-interface.patch 915ecd5efe7a9ab09fc073c8131687184a45dfa4 Wnn/jutil/atod.c Wnn/jutil/ujisf.c

emit_header 0021-fix-qsort-comparator-signatures.patch \
  'Use the standard qsort comparator signature at direct call sites.' \
  915ecd5efe7a9ab09fc073c8131687184a45dfa4 yes
append_commit 0021-fix-qsort-comparator-signatures.patch 915ecd5efe7a9ab09fc073c8131687184a45dfa4 \
  PubdicPlus/pod.c Wnn/jlib/jl.c Wnn/jserver/jikouho.c Wnn/jserver/jikouho_d.c Wnn/jutil/atof.c

emit_header 0022-fix-jlib-handler-callback-prototypes.patch \
  'Declare jl_dic_add_e handler callback arguments.' \
  a85b88729c2fa7d0a2ec542d737c5e19061c8a47 yes
append_commit 0022-fix-jlib-handler-callback-prototypes.patch a85b88729c2fa7d0a2ec542d737c5e19061c8a47 Wnn/include/jllib.h

emit_header 0023-fix-internal-callback-prototypes.patch \
  'Provide prototypes for internal helper and callback functions.' \
  '742ad8cfc4700dbe5b972b48c31cf99ca771bafa; ce301deef6b0a1be7178ea46b6e8690e7d61bad9; 9618769b8e758f537db180a9389c7ce10c536163' yes
append_commit 0023-fix-internal-callback-prototypes.patch 742ad8cfc4700dbe5b972b48c31cf99ca771bafa PubdicPlus/pod.c
append_commit 0023-fix-internal-callback-prototypes.patch ce301deef6b0a1be7178ea46b6e8690e7d61bad9 Wnn/etc/xutoj.c
append_commit 0023-fix-internal-callback-prototypes.patch 9618769b8e758f537db180a9389c7ce10c536163 Wnn/jserver/jikouho_d.c Wnn/jserver/kaiseki.h

direct 0024-fix-romkan-callback-prototypes.patch \
  'Give romkan internal callbacks complete prototypes.' \
  ec458640d9069c4c5bba1a8c63c48fd64e67e62d Wnn/romkan/rk_fundecl.h Wnn/romkan/rk_main.c Wnn/romkan/rk_modread.c

emit_header 0025-fix-byte-buffer-pointer-types.patch \
  'Use byte-buffer pointer types compatible with their callers.' \
  '915ecd5efe7a9ab09fc073c8131687184a45dfa4; 3cc4bf1f5fd9178741dd904612f2110a9470e86b' yes
append_commit 0025-fix-byte-buffer-pointer-types.patch 915ecd5efe7a9ab09fc073c8131687184a45dfa4 Wnn/jserver/de_header.h Wnn/jserver/snd_rcv.c
git diff 3cc4bf1f5fd9178741dd904612f2110a9470e86b^ 3cc4bf1f5fd9178741dd904612f2110a9470e86b -- Wnn/etc/sstrings.c | filterdiff --hunks=1 >> "$P/0025-fix-byte-buffer-pointer-types.patch"

emit_header 0030-fix-signal-handler-signatures.patch \
  'Give signal handlers the required integer argument.' \
  '96a117bd46478eb890f1e9f8e6f0a1a979f1fcb7; 9618769b8e758f537db180a9389c7ce10c536163' yes
append_commit 0030-fix-signal-handler-signatures.patch 96a117bd46478eb890f1e9f8e6f0a1a979f1fcb7 Wnn/jlib/js.c
git diff 9618769b8e758f537db180a9389c7ce10c536163^ 9618769b8e758f537db180a9389c7ce10c536163 -- Wnn/jserver/de.c >> "$P/0030-fix-signal-handler-signatures.patch"
git diff 9618769b8e758f537db180a9389c7ce10c536163^ 9618769b8e758f537db180a9389c7ce10c536163 -- Wnn/jserver/de_header.h | filterdiff --hunks=1 >> "$P/0030-fix-signal-handler-signatures.patch"
git diff 9618769b8e758f537db180a9389c7ce10c536163^ 9618769b8e758f537db180a9389c7ce10c536163 -- Wnn/jserver/error.c | filterdiff --hunks=1 >> "$P/0030-fix-signal-handler-signatures.patch"

emit_header 0031-make-jserver-out-variadic.patch \
  'Implement the jserver debug out function as truly variadic.' \
  9618769b8e758f537db180a9389c7ce10c536163 yes
git diff 9618769b8e758f537db180a9389c7ce10c536163^ 9618769b8e758f537db180a9389c7ce10c536163 -- Wnn/jserver/de_header.h | filterdiff --hunks=2 >> "$P/0031-make-jserver-out-variadic.patch"
git diff 9618769b8e758f537db180a9389c7ce10c536163^ 9618769b8e758f537db180a9389c7ce10c536163 -- Wnn/jserver/error.c | filterdiff --hunks=2 >> "$P/0031-make-jserver-out-variadic.patch"

direct 0032-make-atof-error-format-variadic.patch \
  'Pass atof error formatting arguments with a variadic helper.' \
  d6f15ea6cb13c5f588d0f88f1ccdfdcf01fe437c Wnn/jutil/atof.c

emit_header 0040-fix-wnn-sStrncpy-conversion.patch \
  'Fix wnn_sStrncpy to convert internal w_char text to external EUC.' \
  3cc4bf1f5fd9178741dd904612f2110a9470e86b yes
git diff 3cc4bf1f5fd9178741dd904612f2110a9470e86b^ 3cc4bf1f5fd9178741dd904612f2110a9470e86b -- Wnn/etc/sstrings.c | filterdiff --hunks=2 >> "$P/0040-fix-wnn-sStrncpy-conversion.patch"

direct 0041-fix-jishoop-ENDPTR-comparison.patch \
  'Compare the jishoop pointer with ENDPTR using the intended pointer type.' \
  30049dbe4d9d4b897c531d12d98e2e4ece44adbc Wnn/jserver/jishoop.c
direct 0042-fix-b-index-result-comparison.patch \
  'Compare the b_index result with its integer failure sentinel.' \
  49963ccc1986b5c8e17c4fa65d38cd0faf1523ab Wnn/jserver/b_index.c
direct 0043-use-int-for-romkan-buffer-index.patch \
  'Use int for the romkan buffer index used to subscript character data.' \
  dc4ae760fa346a6e2cadf81fbb0bb70896dd5ab4 Wnn/romkan/rk_main.c

cat > "$P/series" <<'EOF'
0001-configure-check-standard-headers.patch
0002-configure-fix-termcap-tests.patch
0003-configure-fix-libwrap-test.patch
0004-configure-use-default-source.patch
0005-build-dictionaries-in-C-locale.patch
0010-use-system-libc-declarations.patch
0011-fix-bundled-getopt-declarations.patch
0012-remove-redundant-project-declarations.patch
0020-fix-sort-callback-interface.patch
0021-fix-qsort-comparator-signatures.patch
0022-fix-jlib-handler-callback-prototypes.patch
0023-fix-internal-callback-prototypes.patch
0024-fix-romkan-callback-prototypes.patch
0025-fix-byte-buffer-pointer-types.patch
0030-fix-signal-handler-signatures.patch
0031-make-jserver-out-variadic.patch
0032-make-atof-error-format-variadic.patch
0040-fix-wnn-sStrncpy-conversion.patch
0041-fix-jishoop-ENDPTR-comparison.patch
0042-fix-b-index-result-comparison.patch
0043-use-int-for-romkan-buffer-index.patch
0050-define-MAXPATHLEN-fallback.patch
1000-debian-filesystem-layout.patch
1001-fix-manpage-sections.patch
1002-escape-hyphen-in-atod-manpage.patch
EOF
