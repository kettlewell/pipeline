#!/usr/bin/env bash
#
##  run.sh
#

# DESCRIPTION:
# run various pipeline scenarios after the docker containers
# have setup all the foundation pieces


# USAGE
#
# -h help
# -t testname
#
#

set -e

function usage(){
    echo "run.sh -t testname -h"
    echo ""
    echo "testname can be one of:"
    echo -en "\ttest1\n\ttest2"
    return 0
}

usage
