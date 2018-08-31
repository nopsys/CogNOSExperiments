#!/usr/bin/env bash
SCRIPT_PATH="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"
if [ ! -d $SCRIPT_PATH ]; then
    echo "Could not determine absolute dir of $0"
    echo "Maybe accessed with symlink"
fi

exec 4<&1
exec 1>/dev/null
exec 2>&1

source "$SCRIPT_PATH/../../scripts/basicFunctions.inc"
BASE_DIR="$SCRIPT_PATH/../.."
source "$SCRIPT_PATH/../../scripts/config.inc"

FILENAME=$(pwd)/$COGNOS_EXP_OUTPUT_FILE
VBoxManage modifyvm "$COGNOS_VMNAME" --uartmode1 file $FILENAME

INFO "Building image for experiment"
pushd "$IMAGE_DIR" > /dev/null
cp "$COGNOS_DEV_IMAGE_NAME.image" "$COGNOS_DEV_IMAGE_NAME.image.bak"
cp "$PERFORMANCE_ST_SCRIPTS_DIR/$ST_PERFORFORMANCE_HARNESS_TEMPLATE_FILENAME" "$ST_PERFORFORMANCE_HARNESS_FILENAME"
sed -i.bak s/EXPERIMENT/$2/g "$ST_PERFORFORMANCE_HARNESS_FILENAME"
sed -i.bak s/ITERATIONSOUTER/$3/g "$ST_PERFORFORMANCE_HARNESS_FILENAME"
sed -i.bak s/ITERATIONSINNER/$4/g "$ST_PERFORFORMANCE_HARNESS_FILENAME"
rm "$ST_PERFORFORMANCE_HARNESS_FILENAME.bak"
./pharo-ui "$COGNOS_DEV_IMAGE_NAME.image" "$ST_PERFORFORMANCE_HARNESS_FILENAME"
rm "$ST_PERFORFORMANCE_HARNESS_FILENAME"
popd > /dev/null
pushd "$BUILD_DIR" > /dev/null
if [ -f "../../../nopsys/build/nopsys.iso" ]
then
    rm "../../../nopsys/build/nopsys.iso"
fi
make try-virtualbox-iso > /dev/null
popd > /dev/null
while ! grep -q "FINISHHHHH" "$FILENAME" > /dev/null;
do
    sleep 1s
done
pushd "$IMAGE_DIR"
mv "$COGNOS_DEV_IMAGE_NAME.image.bak" "COGNOS_DEV_IMAGE_NAME.image"
popd > /dev/null
tail -n +9 $COGNOS_EXP_OUTPUT_FILE > $COGNOS_EXP_OUTPUT_FILE.bak2
mv $COGNOS_EXP_OUTPUT_FILE.bak2 $COGNOS_EXP_OUTPUT_FILE
sed -i.bak s/FINISHHHHH//g $COGNOS_EXP_OUTPUT_FILE
rm $COGNOS_EXP_OUTPUT_FILE.bak
VBoxManage controlvm "$COGNOS_VMNAME" poweroff
exec 1<&4
cat $COGNOS_EXP_OUTPUT_FILE
sleep 3s
exit 0
