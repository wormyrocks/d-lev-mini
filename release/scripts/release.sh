#!/bin/bash

GRBDIR=~/GitHub/gerbolyze

set -x
cd $(dirname "$0")
. ./functions.sh
cd ../../

creategerbers d-lev-tuner
gbtmp ${retval}
open ${retval}
