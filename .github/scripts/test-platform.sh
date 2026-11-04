#!/usr/bin/env bash
set -euo pipefail

compiler=$1
backend=$2
failures=()

case "$backend" in
  portable|avx2|aarch64) ;;
  *) echo "Unknown backend: $backend" >&2; exit 1 ;;
esac

check_implementation() {
  local name=$1
  local implementation=$2
  local target_flags=${3:-}

  echo "::group::$name"
  if bash .github/scripts/check-cpu.sh "$implementation" "$target_flags" "$compiler" &&
     bash .github/scripts/test.sh "$implementation" "$compiler" "$target_flags"; then
    echo "$name passed"
  else
    failures+=("$name")
    echo "::error::$name failed"
  fi
  echo "::endgroup::"
}

check_implementation Reference Reference_Implementation
check_implementation OptC Optimized_Implementation

case "$backend" in
  avx2)
    check_implementation AVX2 Additional_Implementation/avx2
    ;;
  aarch64)
    check_implementation "AArch64 / portable SHAKE256" Additional_Implementation/aarch64 -march=armv8-a
    check_implementation "AArch64 / SHA3" Additional_Implementation/aarch64 -march=armv8.2-a+sha3
    ;;
esac

if ((${#failures[@]})); then
  printf 'Failed implementation: %s\n' "${failures[@]}"
  exit 1
fi

echo "All implementations passed"
