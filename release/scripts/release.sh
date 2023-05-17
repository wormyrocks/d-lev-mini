#!/bin/bash
set -xe

# per-run settings
project=d-lev-tuner
preview_type=vector
use_round_tracks=0

GRBDIR=~/GitHub/gerbolyze
cd $(dirname "$0")
. ./functions.sh
cd ../../
USE_ROUND_TRACKS=
[[ "$use_round_tracks" == "0" ]] || USE_ROUND_TRACKS=-rounded

PROJECT=${project}${USE_ROUND_TRACKS}
REPO_ROOT=$(pwd)
S_EXP_DIR=${REPO_ROOT}/d-lev-libraries/art.pretty
WORK_DIR=${REPO_ROOT}/release/${PROJECT}_wip
GERBER_DIR=${WORK_DIR}/gerbers
SVG_DIR=${WORK_DIR}/svg
LAYERS="F.Cu,In1.Cu,In2.Cu,B.Cu,F.Mask,B.Mask,F.Silkscreen,B.Silkscreen,F.Paste,B.Paste,Edge.Cuts"
command -v gerbolyze || source ${GRBDIR}/venv/bin/activate

mkdir -p ${SVG_DIR} ${GERBER_DIR}

SVGTOP=${SVG_DIR}/top.svg
SVGBOTTOM=${SVG_DIR}/bottom.svg

[[ -e ${SVGTOP} && -e ${SVGBOTTOM} ]] || {
	creategerbers ${project}/${PROJECT}.kicad_pcb ${GERBER_DIR}
	[[ -e ${SVGTOP} ]] || gerbolyze template --${preview_type} --top ${WORK_DIR} ${SVGTOP}
	[[ -e ${SVGBOTTOM} ]] || gerbolyze template --${preview_type} --bottom ${WORK_DIR} ${SVGBOTTOM}
	echo ok, svg files created. run this script again to paste or generate s-expressions.
	open ${SVG_DIR}
	exit 0
}


vectorizer=hex-grid
vectorizer=square-grid
vectorizer=binary-contours
vectorizer=poisson-disc

ztmp=$(mktemp -u).zip
#gerbolyze paste ${GERBER_DIR} ${SVGTOP} ${ztmp}
#gerbolyze paste ${ztmp} ${SVGBOTTOM} ${WORK_DIR}/${PROJECT}_pasted.zip
gerbolyze paste ${GERBER_DIR} ${SVGBOTTOM} ${WORK_DIR}/${PROJECT}_pasted.zip

#svg-flatten ${SVGBOTTOM} -o s-exp -b ${vectorizer} --format kicad --sexp-mod-name ${project}-bottom ${WORK_DIR}/${project}-bottom.kicad_mod
#svg-flatten ${SVGTOP} -o s-exp -b ${vectorizer} --format kicad --sexp-mod-name ${project}-top ${WORK_DIR}/${project}-top.kicad_mod
