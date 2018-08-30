#!/usr/bin/env bash


SCRIPT_PATH="$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )"
if [ ! -d $SCRIPT_PATH ]; then
    echo "Could not determine absolute dir of $0"
    echo "Maybe accessed with symlink"
fi

source "$SCRIPT_PATH/basicFunctions.inc"
BASE_DIR="$SCRIPT_PATH/.."
source "$SCRIPT_PATH/config.inc"

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

if [ -f "$PHARO_DEV_IMAGE_DIR/$IMAGE_NAME.image" ]
then
    INFO "Installing are we fast benchmarks into Pharo image"
    cp "$PHARO_DEV_IMAGE_DIR/$COGNOS_DEV_IMAGE_NAME.image" "$ARE_WE_FAST_ST_BENCHS_DIR/$COGNOS_DEV_IMAGE_NAME.image"
    cp "$PHARO_DEV_IMAGE_DIR/$COGNOS_DEV_IMAGE_NAME.changes" "$ARE_WE_FAST_ST_BENCHS_DIR/$COGNOS_DEV_IMAGE_NAME.changes"
    pushd $ARE_WE_FAST_ST_BENCHS_DIR
    $IMAGE_DIR/pharo-ui $COGNOS_DEV_IMAGE_NAME.image build-image.st
    mv "$COGNOS_DEV_IMAGE_NAME.image" "$PHARO_DEV_IMAGE_DIR/$COGNOS_DEV_IMAGE_NAME.image" 
    mv "$COGNOS_DEV_IMAGE_NAME.changes" "$PHARO_DEV_IMAGE_DIR/$COGNOS_DEV_IMAGE_NAME.changes" 
    popd > /dev/null
    OK "done"
fi

if [ "$1" = "-includeUnix" ]
then
    INFO "Building and installing Unix VMs"
        $BASE_DIR/Performance/scripts/buildAndInstall.sh
        $BASE_DIR/Performance/scripts/buildAndInstall.sh interpreter
    OK "done"
fi