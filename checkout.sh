#!/usr/bin/env bash
set -euo pipefail

if ! command -v riff >/dev/null 2>&1; then
  if [[ -z "${INPUT_RIFF_BINARY_URL:-}" ]]; then
    echo "riff is not on PATH; install it or set riff-binary-url" >&2
    exit 1
  fi
  bin_dir="${RUNNER_TEMP:-${TMPDIR:-/tmp}}/riff-action-bin"
  mkdir -p "$bin_dir"
  curl --fail --location --silent --show-error "$INPUT_RIFF_BINARY_URL" -o "$bin_dir/riff"
  chmod +x "$bin_dir/riff"
  echo "$bin_dir" >> "$GITHUB_PATH"
  export PATH="$bin_dir:$PATH"
fi

if [[ -z "$INPUT_PATH" || "$INPUT_PATH" == /* || "/$INPUT_PATH/" == */../* ]]; then
  echo "path must stay inside GITHUB_WORKSPACE" >&2
  exit 1
fi
workspace="$GITHUB_WORKSPACE/$INPUT_PATH"
export RIFF_SERVER="$INPUT_SERVER"
export RIFF_REPO="$INPUT_REPO"
if [[ -n "${INPUT_TOKEN:-}" ]]; then
  export RIFF_TOKEN="$INPUT_TOKEN"
fi

args=(clone "$INPUT_REPO" --rev "$INPUT_REVISION")
if [[ -n "${INPUT_SPARSE:-}" ]]; then
  args+=(--sparse "$INPUT_SPARSE")
fi
args+=("$workspace")
riff "${args[@]}"
echo "path=$workspace" >> "$GITHUB_OUTPUT"
