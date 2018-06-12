#!/usr/bin/env bash

SCRIPT_PATH=`dirname $0`

source "$SCRIPT_PATH/../scripts/basicFunctions.inc"

BASE_DIR="$SCRIPT_PATH/.."
COGNOS_DIR="$BASE_DIR/CogNOS"
INSTALL_VMS_DIR=

pushd $COGNOS_DIR
INFO "Building interpreter"
./scripts/buildSources.sh interpreter
OK "Done"
INFO "Building JIT"
./scripts/buildSources.sh
OK "Done"
