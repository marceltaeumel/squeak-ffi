#!/bin/bash
set -e

[[ -z "${SMALLTALK_CI_HOME}" ]] && exit 2
[[ -z "${SMALLTALK_CI_BUILD_BASE}" ]] && exit 6

source "${SMALLTALK_CI_HOME}/helpers.sh" # download_file extract_file ...
source "${SMALLTALK_CI_HOME}/squeak/run.sh" # get_vm_details

pushd "${SMALLTALK_CI_BUILD_BASE}"
ls -lisa
popd

# squeak::test_project
