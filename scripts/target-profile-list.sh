#!/bin/bash

UINTENT_ROOT=$(pwd)

LIST="$(tr " " "\n" < "$UINTENT_ROOT/targets/$UINTENT_PRITARGET-$UINTENT_SUBTARGET")"

echo "$LIST"