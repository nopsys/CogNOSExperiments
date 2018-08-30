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

FILENAME=$(pwd)/$OUTPUT_FILE
VBoxManage modifyvm "$COGNOS_VMNAME" --uartmode1 file $FILENAME

INFO "Building image for experiment"
pushd "$IMAGE_DIR" > /dev/null
cp $IMAGE_NAME $IMAGE_NAME.bak
cp ST_FILENAME_PATH $ST_FILENAME
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
VBoxManage controlvm "$COGNOS_VMNAME" poweroff
exec 1<&4
cat $OUTPUT_FILE
sleep 3s
exit 0
