#!/usr/bin/env bash

SCRIPT_PATH=`dirname $0`

exec 4<&1
exec 1>/dev/null
exec 2>&1

VMNAME=$1
OUTPUT=`vboxmanage list runningvms`
if [[ ! $OUTPUT = *"$VMNAME"* ]]
then
    # Enable serial port
    vboxmanage startvm $VMNAME
fi

if [ $1 = "Ubuntu" ]
then
    sleep 12s
else
    sleep 8s
fi
exec 1<&4
ssh -X osboxes@localhost -p 25000 -i CogNOSExperiments CogNOSExperiments/SmalltalkPerformance/implementations/runPharo.sh ${@:2}
exec 1>/dev/null
VBoxManage controlvm $VMNAME acpipowerbutton
exit 0