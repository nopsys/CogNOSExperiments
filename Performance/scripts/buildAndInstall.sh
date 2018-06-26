#!/usr/bin/env bash
set -e

SCRIPT_PATH=`dirname $0`

source "$SCRIPT_PATH/../../scripts/basicFunctions.inc"

BASE_DIR="../.."
COGNOS_DIR="$BASE_DIR/CogNOS"
VM_DEV_DIR="$COGNOS_DIR/opensmalltalk-vm/image"
VM_BUILD_DIR="$COGNOS_DIR/opensmalltalk-vm/build.linux64x64"
INT_BUILD_DIR="$COGNOS_DIR/opensmalltalk-vm/"
INSTALL_DIR="$BASE_DIR/Performance/implementations"
PRODUCTS_DIR="$COGNOS_DIR/opensmalltalk-vm/products"

pushd $VM_DEV_DIR
source get64VMName.sh

if [ "$1" = "interpreter" ]    
then
	PRODUCTS_NAME="sqstkspur64linuxht"
    INFO "Generating Interpreter Sources"
    FILENAME="../../../Performance/scripts/smalltalk/buildInterpreterSources.st"
    VM_VERSION_BUILD_DIR="$VM_BUILD_DIR/squeak.stack.spur/build"
else  
	PRODUCTS_NAME="cogspur64linuxht"
    INFO "Generating JIT Sources"
    FILENAME="../../../Performance/scripts/smalltalk/buildJitSources.st"
    VM_VERSION_BUILD_DIR="$VM_BUILD_DIR/pharo.cog.spur/build"
fi

INFO "Building sources"
$VM -headless $BASE64.image $FILENAME
popd > /dev/null

pushd "$VM_VERSION_BUILD_DIR"
    echo "y" | ./mvm
popd > /dev/null

if [ ! -d $INSTALL_DIR ]
then
    mkdir $INSTALL_DIR
fi

mv $PRODUCTS_DIR/$PRODUCTS_NAME $INSTALL_DIR/$PRODUCTS_NAME

OK "done"


