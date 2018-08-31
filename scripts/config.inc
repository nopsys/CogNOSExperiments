#!/bin/bash

set -e  # exit on error

# Directories 
COGNOS_DIR="$BASE_DIR/CogNOS"
BUILD_DIR="$COGNOS_DIR/opensmalltalk-vm/platforms/nopsys/"
IMAGE_DIR="$COGNOS_DIR/image"
ARE_WE_FAST_ST_BENCHS_DIR="$BASE_DIR/are-we-fast-yet/benchmarks/Smalltalk/"
VM_DEV_DIR="$BASE_DIR/opensmalltalk-vm/image"

VM_UNIX_DEV_DIR="$COGNOS_DIR/opensmalltalk-vm/image"
INT_BUILD_DIR="$COGNOS_DIR/opensmalltalk-vm/"
VM_UNIX_INSTALL_DIR="$BASE_DIR/Performance/implementations"
VM_UNIX_PRODUCTS_DIR="$COGNOS_DIR/opensmalltalk-vm/products"
VM_UNIX_BUILD_DIR="$COGNOS_DIR/opensmalltalk-vm/build.linux64x64"
VM_UNIX_INT_BUILD_DIR="$VM_UNIX_BUILD_DIR/squeak.stack.spur/build"
VM_UNIX_JIT_BUILD_DIR="$VM_UNIX_BUILD_DIR/pharo.cog.spur/build"

PERFORMANCE_ST_SCRIPTS_DIR="$BASE_DIR/Performance/scripts/smalltalk"

# Artifact names
COGNOS_VMNAME="CogNOS-iso-debug"
ST_PERFORFORMANCE_HARNESS_FILENAME="prepareForExperiment.st"
ST_PERFORFORMANCE_HARNESS_TEMPLATE_FILENAME="prepareForExperimentsTemplate.st"

COGNOS_EXP_OUTPUT_FILE="resultsFromCogNOS.txt"

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