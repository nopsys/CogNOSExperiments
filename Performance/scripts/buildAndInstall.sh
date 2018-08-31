#!/usr/bin/env bash
set -e

SCRIPT_PATH="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"
if [ ! -d $SCRIPT_PATH ]; then
    echo "Could not determine absolute dir of $0"
    echo "Maybe accessed with symlink"
fi

source "$SCRIPT_PATH/../../scripts/basicFunctions.inc"
BASE_DIR="$SCRIPT_PATH/../.."
source "$SCRIPT_PATH/../../scripts/config.inc"


pushd $VM_UNIX_DEV_DIR
source get64VMName.sh

if [ "$1" = "interpreter" ]    
then
	VM_UNIX_NAME=$VM_UNIX_INT_NAME
    INFO "Generating Interpreter Sources"
    FILENAME=$VM_UNIX_BUILDSOURCES_INT_FILENAME
    VM_VERSION_BUILD_DIR=$VM_UNIX_INT_BUILD_DIR
else  
	VM_UNIX_NAME=$VM_UNIX_JIT_NAME
    INFO "Generating JIT Sources"
    FILENAME=$VM_UNIX_BUILDSOURCES_JIT_FILENAME
    VM_VERSION_BUILD_DIR=$VM_UNIX_JIT_BUILD_DIR
fi

INFO "Building sources"
$VM -headless $BASE64.image $FILENAME
popd > /dev/null

pushd "$VM_VERSION_BUILD_DIR"
    echo "y" | ./mvm
popd > /dev/null

if [ ! -d $VM_UNIX_INSTALL_DIR ]
then
    mkdir $VM_UNIX_INSTALL_DIR
fi

mv $VM_UNIX_PRODUCTS_DIR/$VM_UNIX_NAME $VM_UNIX_INSTALL_DIR/$VM_UNIX_NAME

OK "done"


