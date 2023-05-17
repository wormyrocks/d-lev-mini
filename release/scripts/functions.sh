#!/bin/bash

# this might be useful eventually
# https://jeffmcbride.net/programmatic-layout-with-kicad-and-python/
# https://atomic14.com/2022/10/24/kicad-python-scripting-cheat-sheet-copy.html

###### kicad-cli functions 
LAYERS="F.Cu,In1.Cu,In2.Cu,B.Cu,F.Mask,B.Mask,F.Silkscreen,B.Silkscreen,F.Paste,B.Paste,Edge.Cuts"
creategerbers() { 
	kicad-cli pcb export gerbers -l ${LAYERS} -o ${2} ${1} --no-refdes
	kicad-cli pcb export drill --format gerber -o ${2}/ ${1} --excellon-separate-th
	NEWGBRDIR=${WORKDIR}/${1}
}
##########################

###### gerbolyze template creation
command -v gerbolyze || source ${GRBDIR}/venv/bin/activate

#### gerbolyze output

vectorizer=hex-grid
vectorizer=square-grid
vectorizer=binary-contours
vectorizer=poisson-disc

# gerber files
gbpaste() {
	modname=$(basename "${1%%.*}")
	OUTDIR=${WORKDIR}/${modname}-gerbolyzed
	mkdir -p ${OUTDIR}
	gerbolyze paste ${2} $(pwd)/${1} ${OUTDIR}
}

# s-exp
svgf() {
	modname=$(basename "${1%%.*}")
	svg-flatten ${1} -o s-exp -b ${vectorizer} --format kicad --sexp-mod-name ${modname} ${modname}.kicad_mod
	mv ${modname}.kicad_mod d-lev-libraries/art.pretty
}

##########################
