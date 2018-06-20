#!/bin/bash
SCRIPT_PATH=`dirname $0`

RESULTS_FILE_NAME="boottime.data"
scripts/runExperimentInVBox.sh "Ubuntu"
scripts/runExperimentInVBox.sh "Ubuntu-Server"
scripts/runExperimentInVBox.sh "CogNOS-iso-debug"

rm $RESULTS_FILE_NAME
cat *.data >> $RESULTS_FILE_NAME
mv $RESULTS_FILE_NAME $RESULTS_FILE_NAME.bak
rm *.data
mv $RESULTS_FILE_NAME.bak $RESULTS_FILE_NAME 