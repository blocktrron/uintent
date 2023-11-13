#!/usr/bin/env bash

if ! compgen -G "${UINTENT_CONFIG_DIR}/profile/*.json" > /dev/null; then
	echo "ERROR: at least one config profile must exist"
	exit 1
fi

for FILENAME in "${UINTENT_CONFIG_DIR}"/profile/*.json; do
	PYTHON_OUT=$(python3 -m json.tool "$FILENAME" 2>&1)
	PYTHON_ECO=$?

	if [ "$PYTHON_ECO" -ne "0" ]; then
		echo "ERROR: $FILENAME contains no valid json"
		echo "${PYTHON_OUT}"
		exit 2
	fi
done
