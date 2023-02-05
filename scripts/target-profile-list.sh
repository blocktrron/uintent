#!/bin/bash

UINTENT_ROOT=$(pwd)

LIST="$(cat $UINTENT_ROOT/targets/$UINTENT_PRITARGET-$UINTENT_SUBTARGET | tr " " "\n")"

echo "$LIST"