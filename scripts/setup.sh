#!/usr/bin/env bash

source `dirname $0`/basicFunctions.inc

BASE_DIR=".."
IMAGE_DIR="$BASE_DIR/CogNOS/image"
IMAGE_NAME="SqueakNOS"
ARE_WE_FAST_DIR="$BASE_DIR/are-we-fast-yet/benchmarks/Smalltalk/"

INFO "Initializing submodules"
pushd $BASE_DIR
    load_submodule
popd > /dev/null
OK "Submodules initialized"

INFO "Initializing CogNOS"
pushd CogNOS
./scripts/setupRepo.sh
popd > /dev/null
OK "Submodules initialized"

INFO "Configuring Sparse checkout for the are-we-fast benchmarks submodule"
cat > "$BASE_DIR/.git/modules/are-we-fast-yet/info/sparse-checkout" << EOF
benchmarks/Smalltalk/*
EOF

pushd $BASE_DIR/are-we-fast-yet/
    git config core.sparsecheckout true
    git read-tree -mu HEAD
popd > /dev/null
OK "Sparse checkout configured"

if [ -f "$IMAGE_DIR/$IMAGE_NAME.image" ]
then
    INFO "Installing are we fast benchmarks into Pharo image"
    cp "$IMAGE_DIR/$IMAGE_NAME.image" "$ARE_WE_FAST_DIR/$IMAGE_NAME.image"
    pushd $ARE_WE_FAST_DIR
    $IMAGE_DIR/pharo-ui build-image.st
    mv "$ARE_WE_FAST_DIR/$IMAGE_NAME.image" "$IMAGE_DIR/$IMAGE_NAME.image" 
    popd > /dev/null
    OK "done"
fi
