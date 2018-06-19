#!/usr/bin/env bash
SCRIPT_PATH=`dirname $0`

exec 4<&1
exec 1>/dev/null
exec 2>&1

source "$SCRIPT_PATH/../../scripts/basicFunctions.inc"

BASE_DIR="../.."
COGNOS_DIR="$BASE_DIR/CogNOS"
IMAGE_DIR="$COGNOS_DIR/image"
BUILD_DIR="$COGNOS_DIR/opensmalltalk-vm/platforms/nopsys/"
IMAGE_NAME="SqueakNOS.image"
VMNAME="cognos"
ST_FILENAME_TP="../../SmalltalkPerformance/scripts/smalltalk/prepareForExperimentsTemplate.st"
ST_FILENAME="prepareForExperiment.st"
OUTPUT_FILE="resultsFromCogNOS.txt"

FILENAME=$(pwd)/$OUTPUT_FILE
VBoxManage modifyvm "CogNOS-iso-debug" --uartmode1 file $FILENAME

INFO "Building image for experiment"
pushd "$IMAGE_DIR" > /dev/null
cp $IMAGE_NAME $IMAGE_NAME.bak
cp $ST_FILENAME_TP $ST_FILENAME
sed -i.bak s/EXPERIMENT/$2/g $ST_FILENAME
sed -i.bak s/ITERATIONSOUTER/$3/g $ST_FILENAME
sed -i.bak s/ITERATIONSINNER/$4/g $ST_FILENAME
rm $ST_FILENAME.bak
./pharo-ui $IMAGE_NAME $ST_FILENAME
rm $ST_FILENAME
popd > /dev/null
pushd "$BUILD_DIR" > /dev/null
if [ -f "../../../nopsys/build/nopsys.iso" ]
then
    rm "../../../nopsys/build/nopsys.iso"
fi
make try-virtualbox-iso > /dev/null
popd > /dev/null
while ! grep -q "FINISHHHHH" "$OUTPUT_FILE" > /dev/null;
do
    sleep 1s
done
pushd "$IMAGE_DIR"
mv $IMAGE_NAME.bak $IMAGE_NAME
popd > /dev/null
tail -n +9 $OUTPUT_FILE > $OUTPUT_FILE.bak2
mv $OUTPUT_FILE.bak2 $OUTPUT_FILE
sed -i.bak s/FINISHHHHH//g $OUTPUT_FILE
rm $OUTPUT_FILE.bak
VBoxManage controlvm "CogNOS-iso-debug" poweroff
exec 1<&4
cat $OUTPUT_FILE
sleep 3s
exit 0