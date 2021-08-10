#!/bin/bash
set -e

[[ -z "${SMALLTALK_CI_HOME}" ]] && exit 2
[[ -z "${SMALLTALK_CI_BUILD_BASE}" ]] && exit 6

source "${SMALLTALK_CI_HOME}/helpers.sh" # download_file extract_file ...
source "${SMALLTALK_CI_HOME}/squeak/run.sh" # get_vm_details

config_vm="${VM_FILEPATH}"
config_headless="true"

echo '::group::Test image from Windows ...'
SMALLTALK_CI_BUILD="${SMALLTALK_CI_BUILD_BASE}/windows-latest"
config_image="${SMALLTALK_CI_BUILD}/windows-latest/TravisCI.image"
squeak::test_project
echo '::endgroup::'

echo '::group::Test image from Linux ...'
SMALLTALK_CI_BUILD="${SMALLTALK_CI_BUILD_BASE}/ubuntu-latest"
config_image="${SMALLTALK_CI_BUILD}/ubuntu-latest/TravisCI.image"
squeak::test_project
echo '::endgroup::'

echo '::group::Test image from macOS ...'
SMALLTALK_CI_BUILD="${SMALLTALK_CI_BUILD_BASE}/macos-latest"
config_image="${SMALLTALK_CI_BUILD}/macos-latest/TravisCI.image"
squeak::test_project
echo '::endgroup::'
