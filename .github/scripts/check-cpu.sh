#!/usr/bin/env bash
set -euo pipefail

implementation=$1
shake256_asm=$2
compiler=$3

if [ "${implementation}" = "Additional_Implementation/avx2" ]; then
  if [ "$(uname -s)" = Darwin ]; then
    sysctl -n machdep.cpu.leaf7_features | grep -qw AVX2
    sysctl -n machdep.cpu.features | grep -qw AES
  elif [ "${RUNNER_OS:-}" = Windows ]; then
    probe_dir=$(mktemp -d)
    trap 'rm -rf "$probe_dir"' EXIT
    cat > "$probe_dir/avx2.c" <<'EOF'
int main(void) {
  __builtin_cpu_init();
  return !(__builtin_cpu_supports("avx2") &&
           __builtin_cpu_supports("aes") &&
           __builtin_cpu_supports("bmi2") &&
           __builtin_cpu_supports("popcnt"));
}
EOF
    "${compiler}" -O2 -mavx2 "$probe_dir/avx2.c" -o "$probe_dir/avx2.exe"
    "$probe_dir/avx2.exe"
  else
    grep -qw avx2 /proc/cpuinfo
    grep -qw aes /proc/cpuinfo
  fi
elif [ "${shake256_asm}" = 1 ]; then
  if [ "$(uname -s)" = Darwin ]; then
    test "$(sysctl -n hw.optional.arm.FEAT_SHA3)" = 1
  else
    grep -qw sha3 /proc/cpuinfo
  fi
fi
