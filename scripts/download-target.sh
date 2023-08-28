#!/bin/bash

set -e

UINTENT_ROOT=$(pwd)

CHECKSUM_PATH="$UINTENT_ROOT/$UINTENT_DLDIR/$UINTENT_PRITARGET-$UINTENT_SUBTARGET-checksums.txt"

download_checksum() {
	curl -o "$CHECKSUM_PATH" "${OPENWRT_DOWNLOAD_URL}/releases/${OPENWRT_VERSION}/targets/${UINTENT_PRITARGET}/${UINTENT_SUBTARGET}/sha256sums"
}

if [ ! -f "$CHECKSUM_PATH" ]; then
	download_checksum
fi


FILES="sdk imagebuilder"
for file in $FILES; do
	FILENAME="$("$UINTENT_ROOT"/scripts/openwrt-filename.py "$UINTENT_ROOT/$UINTENT_DLDIR/$UINTENT_PRITARGET-$UINTENT_SUBTARGET-checksums.txt" filename "$file")"
	CHECKSUM="$("$UINTENT_ROOT"/scripts/openwrt-filename.py "$UINTENT_ROOT/$UINTENT_DLDIR/$UINTENT_PRITARGET-$UINTENT_SUBTARGET-checksums.txt" sha256 "$file")"

	DL_PATH="$UINTENT_ROOT/$UINTENT_DLDIR/$CHECKSUM.tar.xz"
	if [ ! -f "$DL_PATH" ]; then
		curl -o "$DL_PATH" "$OPENWRT_DOWNLOAD_URL/releases/$OPENWRT_VERSION/targets/$UINTENT_PRITARGET/$UINTENT_SUBTARGET/$FILENAME"
	fi

	EXTRACT_DIR="$UINTENT_ROOT/$UINTENT_OPENWRT_DIR"
	TARGET_DIR="$EXTRACT_DIR/$file-$UINTENT_PRITARGET-$UINTENT_SUBTARGET-$OPENWRT_VERSION"

	if [ ! -d "$TARGET_DIR" ]; then
		TAR_DIRNAME="$(tar tf "$DL_PATH" | head -1 | cut -f1 -d"/")"
		tar xf "$DL_PATH" -C "$EXTRACT_DIR"
		mv "$EXTRACT_DIR/$TAR_DIRNAME" "$TARGET_DIR"
	fi
done
