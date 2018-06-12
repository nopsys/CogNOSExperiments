#!/usr/bin/env bash
set -e

SCRIPT_PATH=`dirname $0`

source "$SCRIPT_PATH/../scripts/basicFunctions.inc"

BASE_DIR="$SCRIPT_PATH/.."
COGNOS_DIR="$BASE_DIR/CogNOS"
VM_DEV_DIR=$COGNOS_DIR/opensmalltalk-vm/image

pushd $VM_DEV_DIR
source get64VMName.sh

if [ "$1" = "interpreter" ]    
then
	INFO "Generating Interpreter Sources"
    $VM $BASE64.image ../../../SmalltalkPerformance/scripts/smalltalk/buildInterpreterSources.st
else  
	INFO "Generating JIT Sources"
    $VM -headless $BASE64.image ../../../SmalltalkPerformance/scripts/smalltalk/buildJitSources.st
fi

OK "done"
popd > /dev/null

