#!/usr/bin/env bash
set -euo pipefail

implementation_root=$1
compiler=$2
target_flags=${3:-}

set -eu
repository=$PWD

for parameter in 768 864 1152; do
  (
    set -eu
    implementation="${implementation_root}/NTRU+$parameter"
    kat_directory="KAT/NTRU+$parameter"

    echo "Building $implementation"
    CFLAGS="${CFLAGS:-} ${target_flags}" \
      NISTFLAGS="${NISTFLAGS:-} ${target_flags}" \
      make -C "$implementation" clean test PQCgenKAT_kem "CC=${compiler}"

    echo "Running encapsulation/decapsulation tests"
    set +e
    test_output=$("$implementation/build/test" | tr -d '\r')
    test_status=$?
    set -e
    printf '%s\n' "$test_output"
    if [ "$test_status" -ne 0 ] || \
       ! printf '%s\n' "$test_output" | grep -qx 'count: 0'; then
      echo "encapsulation/decapsulation test failed" >&2
      exit 1
    fi

    echo "Checking generated known-answer tests"
    kat_workdir=$(mktemp -d "${TMPDIR:-/tmp}/ntruplus-kat.XXXXXX")
    trap 'rm -rf "$kat_workdir"' EXIT HUP INT TERM
    (
      cd "$kat_workdir"
      "$repository/$implementation/build/PQCgenKAT_kem"
    )

    for extension in req rsp; do
      expected=
      for candidate in "$kat_directory"/*."$extension"; do
        if [ -f "$candidate" ]; then
          expected=$candidate
          break
        fi
      done
      if [ -z "$expected" ]; then
        echo "no .$extension KAT file found in $kat_directory" >&2
        exit 1
      fi
      generated="$kat_workdir/${expected##*/}"
      case "$(uname -s)" in
        MINGW*|MSYS*) tr -d '\r' < "$generated" | cmp - "$expected" ;;
        *) cmp "$generated" "$expected" ;;
      esac
    done

    echo "$implementation passed"
  )
done
