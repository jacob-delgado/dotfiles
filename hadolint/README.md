# hadolint

Stow package for `~/.config/hadolint/config.yaml`. hadolint is a
Dockerfile linter. Used by `lefthook` on pre-commit and by hand.

## Table of contents

- [Layout](#layout)
- [Settings](#settings)
- [Per-project overrides](#per-project-overrides)
- [Fresh-machine setup](#fresh-machine-setup)

## Layout

| File                                    | Stows to                         |
| --------------------------------------- | -------------------------------- |
| `hadolint/.config/hadolint/config.yaml` | `~/.config/hadolint/config.yaml` |

## Settings

Ignored rules:

| Code     | Rule                                      | Why ignored                                |
| -------- | ----------------------------------------- | ------------------------------------------ |
| `DL3008` | apt-get without version pin               | unpinned apt is fine in scratch/dev images |
| `DL3018` | apk add without version pin               | same logic for Alpine                      |
| `DL3015` | apt-get without `--no-install-recommends` | stylistic preference                       |

Trusted registries (skip "use a versioned tag" warnings for these):
`docker.io`, `gcr.io`, `quay.io`, `ghcr.io`, `registry.k8s.io`,
`public.ecr.aws`.

`failure-threshold: warning` makes hadolint exit non-zero only for
`warning`/`error` rules — informational findings don't fail builds.

## Per-project overrides

A repo can drop a `.hadolint.yaml` at the root; it wins. Per-line
disables also work:

```dockerfile
# hadolint ignore=DL3007
FROM nginx:latest
```

## Fresh-machine setup

```sh
brew install hadolint    # in the Brewfile
stow hadolint
```
