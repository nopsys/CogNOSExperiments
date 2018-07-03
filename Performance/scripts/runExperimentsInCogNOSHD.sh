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
ST_FILENAME_TP="../../Performance/scripts/smalltalk/prepareForExperimentsTemplate.st"
ST_FILENAME="prepareForExperiment.st"
OUTPUT_FILE="resultsFromCogNOS.txt"

FILENAME=$(pwd)/$OUTPUT_FILE
VBoxManage modifyvm "cognoshd" --uartmode1 file $FILENAME

INFO "Building image for experiment"
vboxmanage startvm "cognoshd"
while ! grep -q "FINISHHHHH" "$OUTPUT_FILE" > /dev/null;
do
    sleep 1s
done
tail -n +9 $OUTPUT_FILE > $OUTPUT_FILE.bak2
mv $OUTPUT_FILE.bak2 $OUTPUT_FILE
sed -i.bak s/FINISHHHHH//g $OUTPUT_FILE
rm $OUTPUT_FILE.bak
VBoxManage controlvm "cognoshd" poweroff
exec 1<&4
cat $OUTPUT_FILE
sleep 3s
exit 0
