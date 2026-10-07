# jetson-linux-builder

## Instruction index

Read applicable entries in order before the repository guidance below.
Resolve local paths from this repository's root. Read each resolved file once
to avoid duplicate loading and cycles. Resolve references inside imported files
from their real target directories after following symlinks.

### Shared context

These files are optional. Read available files in this order, skipping absent
files and reporting broken or unreadable links:

1. `.agents/organization/AGENTS.md` — organization-wide policy and shared context.
2. `.agents/workspace/AGENTS.md` — workspace scope, coordination, and decisions.

Apply organization guidance, then workspace guidance, then the repository
instructions below. More specific applicable instructions take precedence.

## Repository guidance

- This repository builds an Ubuntu-based image containing NVIDIA Jetson Linux
  release tools and flashing prerequisites under the container's `/workspace`.
- `Dockerfile` downloads the NVIDIA release archive and runs
  `tools/l4t_flash_prerequisites.sh`. `docker-bake.hcl` owns the `build`
  matrix, which targets `linux/amd64`.
- `JETSON_VERSION_PAIRS` is an HCL list in Bake. Keep the newest pair first
  for `latest` tags, and keep Dockerfile arguments, Bake tags, README examples,
  and `.github/workflows/` aligned.
- `Makefile` contains the repository release `VERSION`; it does not provide
  build or test targets. Keep repository and L4T image versions distinct.

## Validation and hardware boundaries

- Use `docker buildx bake --print build` to inspect the resolved configuration.
  This validates rendering, not an image build; there is no dedicated test or
  lint target.
- Actual builds download NVIDIA archives and install packages. Avoid running
  them for documentation-only checks.
- README container examples use privileged access, host networking, and host
  device mounts. Flashing with `flash.sh` can modify attached devices; require
  an explicitly authorized hardware task before running those operations.
- Image build and release workflows publish artifacts; do not trigger publication
  as validation.
