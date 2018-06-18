#!/usr/bin/env bash

BASE=".."
source "$BASE/scripts/basicFunctions.inc"

PAPER_DIR="$BASE/../../../../Writings/Research/Nopsis/"
REPORT_DIR="$BASE/Report"

INFO "Copying files to paper dir"
cp "$REPORT_DIR/images/"*.pdf "$PAPER_DIR/Imagenes/"
cp "$REPORT_DIR/report.tex" "$PAPER_DIR/experiments.tex"
OK "Done"
