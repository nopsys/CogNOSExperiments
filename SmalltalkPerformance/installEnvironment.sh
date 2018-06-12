#!/usr/bin/env bash

SCRIPT_PATH=`dirname $0`

source "$SCRIPT_PATH/../scripts/basicFunctions.inc"

BASE_DIR="$SCRIPT_PATH/.."
COGNOS_DIR="$BASE_DIR/CogNOS"
INSTALL_VMS_DIR=

INFO "Building interpreter"
./buildSources.sh interpreter
OK "Done"
INFO "Building JIT"
./buildSources.sh
OK "Done"
