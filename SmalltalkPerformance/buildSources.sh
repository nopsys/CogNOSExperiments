#!/usr/bin/env bash
set -e

SCRIPT_PATH=`dirname $0`

source "$SCRIPT_PATH/../scripts/basicFunctions.inc"

BASE_DIR="$SCRIPT_PATH/.."
COGNOS_DIR="$BASE_DIR/CogNOS"
VM_DEV_DIR=$COGNOS_DIR/opensmalltalk-vm/image
VM_BUILD_DIR="$COGNOS_DIR/opensmalltalk-vm/build.linux64x64"
INT_BUILD_DIR="$COGNOS_DIR/opensmalltalk-vm/"
INSTALL_DIR="../../../SmalltalkPerformance/implementations/"

pushd $VM_DEV_DIR
source get64VMName.sh

if [ "$1" = "interpreter" ]    
then
	PRODUCTS_DIR="$COGNOS_DIR/opensmalltalk-vm/products/sqstkspur64linuxht"
    INFO "Generating Interpreter Sources"
    $VM -headless $BASE64.image ../../../SmalltalkPerformance/scripts/smalltalk/buildInterpreterSources.st
    INFO "Building Interpreter Sources"
    pushd "$VM_BUILD_DIR/squeak.stack.spur/build"
    echo "Y" | ./mvm
else  
	PRODUCTS_DIR="$COGNOS_DIR/opensmalltalk-vm/products/sqcogspur64linuxht"
    INFO "Generating JIT Sources"
    $VM -headless $BASE64.image ../../../SmalltalkPerformance/scripts/smalltalk/buildJitSources.st
    pushd "$VM_BUILD_DIR/squeak.cog.spur/build"
    echo "Y" | ./mvm
fi

if [ ! -d $INSTALL_DIR ]
then
    mkdir $INSTALL_DIR
fi

mv $PRODUCTS_DIR $INSTALL_DIR

OK "done"
popd > /dev/null

