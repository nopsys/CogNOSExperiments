#!/usr/bin/env bash
set -e

SCRIPT_PATH=`dirname $0`

source "$SCRIPT_PATH/../../scripts/basicFunctions.inc"

BASE_DIR="../.."
COGNOS_DIR="$BASE_DIR/CogNOS"
VM_DEV_DIR="$COGNOS_DIR/image"
BENCH_DATA_DIR_NAME="fileBenchData"

INFO "Building interpreter"
./buildAndInstall.sh interpreter
OK "Done"
INFO "Building JIT"
./buildAndInstall.sh
OK "Done"

INFO "Creating testData for filesystem experiment"
pushd $VM_DEV_DIR
if [ ! -d $BENCH_DATA_DIR_NAME ]
then
    mkdir $BENCH_DATA_DIR_NAME
fi
pushd $BENCH_DATA_DIR_NAME
for ((i=1;i<=100;i++)); 
do 
   echo $i > "$i.data"
done
popd > /dev/null
popd > /dev/null
OK "Done"