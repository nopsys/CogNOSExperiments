#!/bin/bash
SCRIPT_PATH=`dirname $0`

source "$SCRIPT_PATH/../../scripts/basicFunctions.inc"

BASE_DIR="../.."
COGNOS_DIR="$BASE_DIR/CogNOS"
IMAGE_DIR="$COGNOS_DIR/image"
BUILD_DIR="$COGNOS_DIR/opensmalltalk-vm/platforms/nopsys/"
IMAGE_NAME="SqueakNOS.image"
ST_FILENAME="../../Bootloading/scripts/prepareForExperiment.st"
OUTPUT_FILE="CogNOS-boottimes.data"

VM=$1

if [[ $VM = *"CogNOS"* ]]
then
    INFO "Building image for experiment"
    pushd "$IMAGE_DIR" > /dev/null
    cp $IMAGE_NAME $IMAGE_NAME.bak
    ./pharo-ui $IMAGE_NAME $ST_FILENAME
    popd > /dev/null
    FILENAME=$(pwd)/../$OUTPUT_FILE
    VBoxManage modifyvm $VM --uartmode1 file $FILENAME
    pushd "$BUILD_DIR" > /dev/null
    if [ -f "../../../nopsys/build/nopsys.iso" ]
    then
        rm "../../../nopsys/build/nopsys.iso"
    fi
    make try-virtualbox-iso > /dev/null
    popd > /dev/null
else
    vboxmanage startvm $VM
fi


if [[ $VM = *"CogNOS"* ]]
then
    pushd "$IMAGE_DIR"
    mv $IMAGE_NAME.bak $IMAGE_NAME
    popd > /dev/null
    sleep 5s
    pushd "../"
    tail -n +9 $OUTPUT_FILE > $OUTPUT_FILE.bak2
    mv $OUTPUT_FILE.bak2 $OUTPUT_FILE
    sed -i.bak "s/^/$VM, /" $OUTPUT_FILE
    rm $OUTPUT_FILE.bak
    popd > /dev/null
    VBoxManage controlvm $VM poweroff
elif [[ $VM = *"Minix"* ]] 
then
    sleep 5s
    scp -P 25000 -i ../../Keys/CogNOSExperiments root@localhost:/var/startup-log ../$VM-boottimes.data
    sed -i.bak "s/^/$VM, /" ../$VM-boottimes.data
    rm ../$VM-boottimes.data.bak
    VBoxManage controlvm $VM shutdown
    sleep 5s
else
    sleep 20s
    scp -P 25000 -i ../../Keys/CogNOSExperiments osboxes@localhost:/var/startup-log ../$VM-boottimes.data
    sed -i.bak "s/^/$VM, /" ../$VM-boottimes.data
    rm ../$VM-boottimes.data.bak
    VBoxManage controlvm $VM acpipowerbutton
    sleep 10s
fi
