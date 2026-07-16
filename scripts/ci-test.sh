#!/bin/sh

set -eu

if [ "$#" -lt 1 ]; then
	echo "usage: $0 IMPLEMENTATION_DIR [MAKE_ARGUMENT ...]" >&2
	exit 2
fi

implementation=$1
shift

case "$implementation" in
	*/NTRU+768|*/NTRU+864|*/NTRU+1152) ;;
	*)
		echo "unsupported implementation directory: $implementation" >&2
		exit 2
		;;
esac

if [ ! -d "$implementation" ]; then
	echo "implementation directory not found: $implementation" >&2
	exit 2
fi

parameter_set=${implementation##*/}
kat_directory="KAT/$parameter_set"
repository=$(pwd)

echo "Building $implementation"
make -C "$implementation" clean test PQCgenKAT_kem "$@"

echo "Running encapsulation/decapsulation tests"
set +e
test_output=$("$implementation/build/test")
test_status=$?
set -e
printf '%s\n' "$test_output"

if [ "$test_status" -ne 0 ] || ! printf '%s\n' "$test_output" | grep -qx 'count: 0'; then
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
	expected=$(find "$kat_directory" -maxdepth 1 -type f -name "*.$extension" -print -quit)
	if [ -z "$expected" ]; then
		echo "no .$extension KAT file found in $kat_directory" >&2
		exit 1
	fi

	generated="$kat_workdir/${expected##*/}"
	if ! cmp "$generated" "$expected"; then
		echo "generated KAT does not match $expected" >&2
		exit 1
	fi
done

echo "$implementation passed"
