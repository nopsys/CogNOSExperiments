#!/bin/bash

set -e  # exit on error

# Directories 
COGNOS_DIR="$BASE_DIR/CogNOS"
BUILD_DIR="$COGNOS_DIR/opensmalltalk-vm/platforms/nopsys/"
IMAGE_DIR="$COGNOS_DIR/image"
ST_FILENAME_PATH="$BASE_DIR/Performance/scripts/smalltalk/$ST_FILENAME"
ARE_WE_FAST_ST_BENCHS="$BASE_DIR/are-we-fast-yet/benchmarks/Smalltalk/"

VM_UNIX_DEV_DIR="$COGNOS_DIR/opensmalltalk-vm/image"
INT_BUILD_DIR="$COGNOS_DIR/opensmalltalk-vm/"
VM_UNIX_INSTALL_DIR="$BASE_DIR/Performance/implementations"
VM_UNIX_PRODUCTS_DIR="$COGNOS_DIR/opensmalltalk-vm/products"
VM_UNIX_BUILD_DIR="$COGNOS_DIR/opensmalltalk-vm/build.linux64x64"
VM_UNIX_INT_BUILD_DIR="$VM_UNIX_BUILD_DIR/squeak.stack.spur/build"
VM_UNIX_JIT_BUILD_DIR="$VM_UNIX_BUILD_DIR/pharo.cog.spur/build"


# Artifact names
IMAGE_NAME="SqueakNOS.image"
COGNOS_VMNAME="CogNOS-iso-debug"
ST_FILENAME="prepareForExperiment.st"
OUTPUT_FILE="resultsFromCogNOS.txt"

PHARO_DEV_IMAGE_DIR="$BASE_DIR/CogNOS/image"
COGNOS_DEV_IMAGE_NAME="SqueakNOS"



VM_UNIX_INT_NAME="sqstkspur64linuxht"
VM_UNIX_JIT_NAME="cogspur64linuxht"
VM_UNIX_BUILDSOURCES_INT_FILENAME="../../../Performance/scripts/smalltalk/buildInterpreterSources.st"
VM_UNIX_BUILDSOURCES_JIT_FILENAME="../../../Performance/scripts/smalltalk/buildJitSources.st"

# Commands
REMOTE_RUN_PHARO_CMD="CogNOSExperiments/Performance/implementations/runPharo.sh"

# Constants
SSH_KEY="../Keys/CogNOSExperiments"
REMOTE_PORT=25000
REMOTE_USER=osboxes