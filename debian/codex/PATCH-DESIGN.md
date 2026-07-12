# Approved patch design

This file is a binding implementation specification.

## Old Debian patch disposition

| Historical patch | Required action |
|---|---|
| `newlayout` | Drop. It is empty. |
| `makerules.mk.in` | Replace with `1000-debian-filesystem-layout.patch`. |
| `man` | Split into `1001-fix-manpage-sections.patch` and `1002-escape-hyphen-in-atod-manpage.patch`. |
| `hardening-flags` | Drop. a023 already propagates CPPFLAGS/LDFLAGS. Add only a new targeted fix if blhc proves a remaining omission. |
| `hurd_support.patch` | Refresh as `0050-define-MAXPATHLEN-fallback.patch`. |
| `fix-parallel-build.patch` | Drop. a023 contains the corrected dependency implementation. |
| `egrep-a.patch` | Drop and supersede with `0005-build-dictionaries-in-C-locale.patch`. |

## Exact patch series

```text
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
```

## Source commit mapping

### Direct mappings

| Commit | Patch |
|---|---|
| `adefb67746514c2cf16fa19e41275d29e7b280bf` | `0001` |
| `73f4f2d54f7894f7448f10907392f0ee2b146110` | `0002` |
| `d624813b2210db7e7b66688154a3911539809db5` | `0003` |
| `b8c95ad64da5de58857c72f4b3644d90c6e6e53c` | `0004`, `configure.in` only |
| `1195a7660cd0ff31dbe0daec09210338126fa1bf` | `0005` |
| `b90513011520dbe4b34816b0aad62275d0815fbb`, `d582d0ea7dfd937d56f911ee5e1695d45dcc9288` | `0010` |
| `b59c2fc9bf5d301c8dce484f637ec506ac36fb7c` | `0011` |
| `13d0d075a91eebf18e16615a732abcaae2b349b0` | `0012` |
| `742ad8cfc4700dbe5b972b48c31cf99ca771bafa`, `ce301deef6b0a1be7178ea46b6e8690e7d61bad9` | `0023` |
| `ec458640d9069c4c5bba1a8c63c48fd64e67e62d` | `0024` |
| `96a117bd46478eb890f1e9f8e6f0a1a979f1fcb7` | `0030` |
| `d6f15ea6cb13c5f588d0f88f1ccdfdcf01fe437c` | `0032` |
| `30049dbe4d9d4b897c531d12d98e2e4ece44adbc` | `0041` |
| `49963ccc1986b5c8e17c4fa65d38cd0faf1523ab` | `0042` |
| `dc4ae760fa346a6e2cadf81fbb0bb70896dd5ab4` | `0043` |

Do not create a patch from generated-configure commit
`d2ce32b7afd3d79e810c08051c937106cbdf1332`.

### Split `a85b88729c2fa7d0a2ec542d737c5e19061c8a47`

- `Wnn/include/jutil.h` sort callback interface -> `0020`
- `Wnn/include/jllib.h` `jl_dic_add_e` handlers -> `0022`

### Split `17578cf34877cad67c465335afbf499b88cecce1`

- `Wnn/etc/getopt.c` -> `0011`
- redundant declarations in `Wnn/etc/bdic.c` -> `0012`

### Split `915ecd5efe7a9ab09fc073c8131687184a45dfa4`

- `Sorted`, `uniq_je`, internal sort interface -> `0020`
- direct `qsort` comparators -> `0021`
- `jl_dic_add_e` callback types -> `0022`
- other internal callback prototypes -> `0023`
- byte buffer and `fread_cur` pointer types -> `0025`

### Split `9618769b8e758f537db180a9389c7ce10c536163`

- redundant declarations -> `0012`
- internal helper prototypes -> `0023`
- signal handlers -> `0030`
- real variadic `out()` -> `0031`

The variadic implementation must not be hidden in a generic prototype patch.

### Split `3cc4bf1f5fd9178741dd904612f2110a9470e86b`

- byte-buffer signedness/type adjustment -> `0025`
- correct conversion direction in `wnn_sStrncpy()` -> `0040`

Describe `0040` as a functional conversion bug, not warning cleanup.

## Retained Debian patches

### `0050-define-MAXPATHLEN-fallback.patch`

Apply to:

- `Wnn/include/msg.h`
- `Wnn/jserver/de_header.h`

Use `<limits.h>`, `PATH_MAX` when available, then fallback 1024.
Use C comments, not `//`.

### `1000-debian-filesystem-layout.patch`

Use Autoconf directory variables:

- read-only data: `$(datadir)/wnn`
- mutable data: `$(localstatedir)/lib/wnn`
- install owner: `root`

Retain per-language mutable dictionary directories.

### `1001-fix-manpage-sections.patch`

Contain only `.TH` section numbers and cross-reference section corrections.

### `1002-escape-hyphen-in-atod-manpage.patch`

Contain only the `-s` to `\-s` roff correction.

## DEP-3 requirements

Every patch needs:

- `Description`
- `Origin` or `Author`
- `Forwarded`
- `Last-Update`
- source commit hashes in the description
- `Bug-Debian` where known

## Allowed tree differences from GCC reference

After applying the full series, excluding `debian/`, `configure`, and
temporary instruction files, source content must match
`reference/gcc15-main-20260711` except:

- `makerule.mk.in`
- `Wnn/include/msg.h`
- `Wnn/jserver/de_header.h`
- files under `Wnn/man/`
- files under `cWnn/man/`
- files under `kWnn/man/`

Any other difference is a blocker.
