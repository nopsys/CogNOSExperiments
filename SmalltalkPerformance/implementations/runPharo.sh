#!/usr/bin/env bash
set -e

SCRIPT_PATH=`dirname $0`
source "$SCRIPT_PATH/../../scripts/basicFunctions.inc"

IMAGE="../../../CogNOS/image/SqueakNOS.image"

if [ $1 == "--interpreter" ]
then
VM_DIR="sqstkspur64linuxht"
EXECUTALBE="squeak"
elif [ $1 == "--jit" ]
then
VM_DIR="cogspur64linuxht"
EXECUTALBE="pharo"
else
ERR "First argument must be --interpreter or --jit"
fi

pushd $VM_DIR
./$EXECUTALBE $IMAGE ${@:2}    
popd /dev/null