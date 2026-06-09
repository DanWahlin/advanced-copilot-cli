#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: apply-section-02-catchup.sh [--force] [target-repo]

Copies the Section 02 catch-up assets into an AssetTrack repository.
Run from the AssetTrack repository root, or pass the repository path as target-repo.

Options:
  --force   Overwrite existing catch-up files.
USAGE
}

force=false
target_dir="${PWD}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --force|-f)
      force=true
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      target_dir="$1"
      shift
      ;;
  esac
done

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
asset_root="$(cd "${script_dir}/.." && pwd)"
target_dir="$(cd "${target_dir}" && pwd)"

if [[ ! -f "${target_dir}/package.json" || ! -d "${target_dir}/services" ]]; then
  echo "This does not look like the AssetTrack repository root: ${target_dir}" >&2
  echo "Expected to find package.json and services/." >&2
  exit 1
fi

source_files=()
while IFS= read -r relative_path; do
  source_files+=("${relative_path}")
done < <(cd "${asset_root}" && find .github .copilot -type f | sort)

existing=()
for relative_path in "${source_files[@]}"; do
  if [[ -e "${target_dir}/${relative_path}" ]]; then
    existing+=("${relative_path}")
  fi
done

if [[ "${force}" == "false" && ${#existing[@]} -gt 0 ]]; then
  echo "Refusing to overwrite existing files. Re-run with --force to overwrite:" >&2
  printf '  %s\n' "${existing[@]}" >&2
  exit 1
fi

for relative_path in "${source_files[@]}"; do
  mkdir -p "${target_dir}/$(dirname "${relative_path}")"
  cp "${asset_root}/${relative_path}" "${target_dir}/${relative_path}"
done

echo "Section 02 catch-up assets copied to ${target_dir}."
echo
echo "Next verification steps from the AssetTrack repository root:"
echo "  1. Run /instructions and confirm repo and scoped instructions are loaded."
echo "  2. Run /agent and confirm accessibility-updater is available."
echo "  3. Run /skills and confirm make-repo-contribution is available."
