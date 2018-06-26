#!/bin/bash
set -e
SCRIPT_PATH=`dirname $0`

source "$SCRIPT_PATH/../scripts/basicFunctions.inc"

BASE_DIR=".."
COGNOS_DIR="$BASE_DIR/CogNOS"
NOPSYS_DIR="$COGNOS_DIR/nopsys"
NOPSYS_SRC_DIR="$NOPSYS_DIR/src"
SMALLTALK_DIR="$COGNOS_DIR/image"
RESULTS_FILE_NAME="statistics.data"

pushd $NOPSYS_SRC_DIR
mv paging.c paging.c.bak
INFO "Gathering nopsys src lines"
printf "Nopsys,Source code,C,,, " > "../../../SourceCodeStatistics/$RESULTS_FILE_NAME"
cat *.c | sed '/^\s*#/d;/^\s*$/d' | wc -l >> "../../../SourceCodeStatistics/$RESULTS_FILE_NAME"
printf "Nopsys,Font headers,C,,, " >> "../../../SourceCodeStatistics/$RESULTS_FILE_NAME"
cat fonttex.h | sed '/^\s*#/d;/^\s*$/d' | wc -l >> "../../../SourceCodeStatistics/$RESULTS_FILE_NAME"
printf "Nopsys,Debugging console,C,,, " >> "../../../SourceCodeStatistics/$RESULTS_FILE_NAME"
cat console.* | sed '/^\s*#/d;/^\s*$/d' | wc -l >> "../../../SourceCodeStatistics/$RESULTS_FILE_NAME"
printf "Nopsys,Source code headers,C,,, " >> "../../../SourceCodeStatistics/$RESULTS_FILE_NAME"
cat *.h | sed '/^\s*#/d;/^\s*$/d' | wc -l >> "../../../SourceCodeStatistics/$RESULTS_FILE_NAME"
printf "Nopsys,Source code,Assembly,,, " >> "../../../SourceCodeStatistics/$RESULTS_FILE_NAME"
cat *.asm | sed '/^\s*#/d;/^\s*$/d' | wc -l >> "../../../SourceCodeStatistics/$RESULTS_FILE_NAME"
mv paging.c.bak paging.c
pushd "libc"
printf "Nopsys, libc headers,C,,, " >> "../../../../SourceCodeStatistics/$RESULTS_FILE_NAME"
find . -name '*.h' -exec cat {} + | sed '/^\s*#/d;/^\s*$/d' | wc -l >> "../../../../SourceCodeStatistics/$RESULTS_FILE_NAME"
# Should we also include GRUB loc? How can be measure that?
popd > /dev/null
popd > /dev/null
OK "Done" 
INFO "Gathering SqueakNOS Smalltalk Package statistics"
pushd $SMALLTALK_DIR
./pharo SqueakNOS.image "../../SourceCodeStatistics/scripts/SqueakNOSStatistics.st" >> "../../SourceCodeStatistics/$RESULTS_FILE_NAME"
popd > /dev/null
OK "Done" 