#!/bin/bash
set -e

[[ -z "${SMALLTALK_CI_HOME}" ]] && exit 2
[[ -z "${SMALLTALK_CI_BUILD_BASE}" ]] && exit 6

source "${SMALLTALK_CI_HOME}/helpers.sh" # download_file extract_file ...
source "${SMALLTALK_CI_HOME}/squeak/run.sh" # get_vm_details

config_vm="${VM_FILEPATH}"
config_headless="true"

SMALLTALK_CI_VM="${VM_FILEPATH}"

test() {
	SMALLTALK_CI_IMAGE="${SMALLTALK_CI_BUILD}/TravisCI.image"
	config_image="${SMALLTALK_CI_BUILD}/TravisCI.image"
	squeak::run_script "test.st"
}

echo '::group::Test image from Windows ...'
SMALLTALK_CI_BUILD="${SMALLTALK_CI_BUILD_BASE}/windows-latest/TravisCI.image"
test
echo '::endgroup::'

echo '::group::Test image from Linux ...'
SMALLTALK_CI_BUILD="${SMALLTALK_CI_BUILD_BASE}/ubuntu-latest"
test
echo '::endgroup::'

echo '::group::Test image from macOS ...'
SMALLTALK_CI_BUILD="${SMALLTALK_CI_BUILD_BASE}/macos-latest"
test
echo '::endgroup::'
