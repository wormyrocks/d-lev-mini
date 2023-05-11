#!/bin/bash

# this might be useful eventually
# https://jeffmcbride.net/programmatic-layout-with-kicad-and-python/
# https://atomic14.com/2022/10/24/kicad-python-scripting-cheat-sheet-copy.html

retval=""
WORKDIR=$(mktemp -d)

###### kicad-cli functions 
LAYERS="F.Cu,In1.Cu,In2.Cu,B.Cu,F.Mask,B.Mask,F.Silkscreen,B.Silkscreen,F.Paste,B.Paste,Edge.Cuts,"
creategerbers() { 
	mkdir -p ${WORKDIR}/${1}
	kicad-cli pcb export gerbers -l ${LAYERS} -o ${WORKDIR}/${1} ${1}/${1}.kicad_pcb
	kicad-cli pcb export drill --format gerber -o ${WORKDIR}/${1}/ ${1}/${1}.kicad_pcb --excellon-separate-th
	retval=${WORKDIR}/${1}
}
##########################

###### gerbolyze functions 
source ${GRBDIR}/venv/bin/activate

gbtmp() { 
	projfile=$(basename ${1})
	gerbolyze template --vector --top ${1} ${1}/${projfile}-top-gerbolyzed.svg
	gerbolyze template --vector --bottom ${1} ${1}/${projfile}-bottom-gerbolyzed.svg
}
##########################

