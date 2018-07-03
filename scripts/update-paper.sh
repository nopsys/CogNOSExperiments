#!/usr/bin/env bash
set -e

BASE="../"
source `dirname $0`/../scripts/basicFunctions.inc

PAPER_DIR="$BASE../../../../Writings/Research/Nopsis"
REPORT_DIR="$BASE/Report"

INFO "Copying files to paper dir"
cp "$REPORT_DIR/images/"*.pdf "$PAPER_DIR/Imagenes/"

sed -i.bak 's/\/Users\/guidochari\/Documents\/Projects\/Research\/Nopsys\/CogNOSExperiments\/Report\/images/Imagenes/g' $REPORT_DIR/report.tex
cp "$REPORT_DIR/report.tex" "$PAPER_DIR/experiments.tex"
OK "Done"
