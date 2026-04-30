# cran-basic

## Feature exercised

Minimal `packrat/packrat.lock` (PackratFormat 1.4, INI format) with two direct CRAN packages
(`jsonlite` and `httr`) and one explicit transitive (`curl`, required by `httr`). This is the
diagnostic gate probe: if Mend cannot detect and parse this lockfile, no other Packrat probe is
meaningful.

## What this probe tests

- Mend detects `packrat/packrat.lock` at the expected subdirectory path (not repo root).
- Mend's parser handles the INI-like DCF format, not JSON. A JSON-only R resolver returns an empty tree.
- `PackratFormat: 1.4` header is recognised and not dropped.
- `RVersion: 4.3.2` is parsed without error.
- Single `Repos:` entry (`CRAN=https://cran.rstudio.com/`) is attributed correctly.
- All three packages (`jsonlite`, `httr`, `curl`) appear in the output tree.
- `jsonlite` and `httr` are classified as direct; `curl` is classified as transitive under `httr`.
- No DESCRIPTION file is present — this is lockfile-only detection.
- `Hash:` field (MD5 checksum of source tarball) is parsed without error; hashes are not validated
  by Mend against upstream CRAN (they are stored metadata in the lockfile).

## Hash notes

- `jsonlite 1.8.8`: `7ac98928eb5d55c28c99a5e7bc065d2f` — this is the real CRAN DESCRIPTION MD5 as
  documented in PACKRAT_COVERAGE_PLAN.md.
- `httr 1.4.7`: `a8d2c1f9e4b7a3c5d0e6f2a8b1c4d9e3` — plausible-format 32-character hex. The exact
  CRAN MD5 for httr 1.4.7 could not be verified at probe-generation time without network access.
  Syntactically valid; Packrat accepts any 32-char hex.
- `curl 5.2.1`: `e6b5f4a2c3d1e8f7a0b9c4d2e5f3a1b7` — plausible-format 32-character hex. Same caveat.

## Resolver gap note

The upstream UA resolver file for R (`resolvers/r.md`) was not accessible at probe-generation time
(404 on all fetch attempts — see PACKRAT_COVERAGE_PLAN.md §8). The following are therefore unconfirmed:

- Whether Mend reads `packrat/packrat.lock` statically or runs `Rscript -e "packrat::restore()"` as a pre-step.
- Whether `PackratFormat: 1.3` / unversioned lockfiles are in the supported format matrix.
- Whether `packrat.opts` `external.packages` is honoured by the resolver.

This probe is the empirical gate: run it first and check whether the dependency tree is non-empty.

## packrat.opts

Minimal defaults only — `auto.snapshot: FALSE`, `use.cache: FALSE`. No `external.packages` entries.

## Expected dependency tree

### Direct dependencies

| Package | Version | Source |
|---|---|---|
| `jsonlite` | 1.8.8 | registry (CRAN) |
| `httr` | 1.4.7 | registry (CRAN) |

### Transitive dependencies

| Package | Version | Source | Parent |
|---|---|---|---|
| `curl` | 5.2.1 | registry (CRAN) | `httr` |

### Summary

- Total packages in lockfile: **3**
- Direct: **2** (`jsonlite`, `httr`)
- Transitive: **1** (`curl`, under `httr`)
- All sources: **CRAN registry**
- No Bioconductor, GitHub, Bitbucket, GitLab, or local sources

## Mend failure modes exercised

- **Packrat lockfile not detected**: if tree is empty, Mend does not recognise `packrat/packrat.lock`.
- **INI-format parser missing**: JSON-only R resolver silently returns empty tree.
- **`PackratFormat:` header dropped**: detection aborts if required header field is unknown.
- **Transitive dep missing**: `curl` must not be silently dropped.
- **`Hash:` field parse error**: any non-32-char or non-hex value would be a lockfile authoring error, not a Mend issue.

## Probe metadata

```
pattern:              cran-basic
pm:                   packrat
lockfile:             packrat/packrat.lock
packrat_format:       1.4
packrat_version:      0.9.2
r_version:            4.3.2
cran_url:             https://cran.rstudio.com/
total_packages:       3
direct_packages:      2
transitive_packages:  1
generated:            2026-04-30
target:               local
```
