#!/usr/bin/env bash


SCRIPT_PATH="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"
if [ ! -d $SCRIPT_PATH ]; then
    echo "Could not determine absolute dir of $0"
    echo "Maybe accessed with symlink"
fi

source $SCRIPT_PATH/basicFunctions.inc

BASE_DIR="$SCRIPT_PATH/.."
IMAGE_DIR="$BASE_DIR/CogNOS/image"
IMAGE_NAME="SqueakNOS"
ARE_WE_FAST_DIR="$BASE_DIR/are-we-fast-yet/benchmarks/Smalltalk/"

INFO "Initializing submodules"
pushd $BASE_DIR
    load_submodule
popd > /dev/null
OK "Submodules initialized"

INFO "Initializing CogNOS"
pushd "$BASE_DIR/CogNOS"
./scripts/setupRepo.sh -includeUnix
popd > /dev/null
OK "CogNOS initialized"

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
    cp "$IMAGE_DIR/$IMAGE_NAME.changes" "$ARE_WE_FAST_DIR/$IMAGE_NAME.changes"
    pushd $ARE_WE_FAST_DIR
    $IMAGE_DIR/pharo-ui $IMAGE_NAME.image build-image.st
    mv "$IMAGE_NAME.image" "$IMAGE_DIR/$IMAGE_NAME.image" 
    mv "$IMAGE_NAME.changes" "$IMAGE_DIR/$IMAGE_NAME.changes" 
    popd > /dev/null
    OK "done"
fi
