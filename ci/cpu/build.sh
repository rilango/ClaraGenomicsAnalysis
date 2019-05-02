#!/bin/bash
# Copyright (c) 2019, NVIDIA CORPORATION.
######################################
# GenomeWorks CPU build script for CI #
######################################
set -e

# Logger function for build status output
function logger() {
  echo -e "\n>>>> $@\n"
}

################################################################################
# Init
################################################################################

export TEST_PYGENOMEWORKS=1
export PATH=/conda/bin:/usr/local/cuda/bin:$PATH
PARALLEL_LEVEL=4

# Set home to the job's workspace
export HOME=$WORKSPACE

cd ${WORKSPACE}

source ci/common/prep-init-env.sh ${WORKSPACE}

CMAKE_COMMON_VARIABLES="-DCMAKE_BUILD_TYPE=Release"

################################################################################
# SDK build/test
################################################################################

logger "Build SDK..."
source ci/common/build-test-sdk.sh ${WORKSPACE} ${CMAKE_COMMON_VARIABLES} ${PARALLEL_LEVEL} 0

################################################################################
# Pygenomeworks tests
################################################################################

cd ${WORKSPACE}
if [ "${TEST_PYGENOMEWORKS}" == '1' ]; then
    source ci/common/test-pygenomeworks.sh $WORKSPACE/pygenomeworks
fi