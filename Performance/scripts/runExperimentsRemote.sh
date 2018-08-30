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
source "$SCRIPT_PATH/../../scripts/config.inc" > /dev/null


VMNAME="$1"
OUTPUT=`vboxmanage list runningvms`
if [[ ! $OUTPUT = *"$VMNAME"* ]]
then
    # Enable serial port
    vboxmanage startvm $VMNAME
fi

# Give enough times to the VMs to initialize
if [ $1 = "Ubuntu" ]
then
    sleep 20s
else
    sleep 12s
fi
exec 1<&4
ssh -X $REMOTE_USER@localhost -p $REMOTE_PORT -i $SSH_KEY $REMOTE_RUN_PHARO_CMD ${@:2}
exec 1>/dev/null
VBoxManage controlvm $VMNAME acpipowerbutton
sleep 3s
exit 0