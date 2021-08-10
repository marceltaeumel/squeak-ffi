#!/bin/bash
set -e

source "${SMALLTALK_CI_HOME}/helpers.sh" # download_file extract_file
source "${SMALLTALK_CI_HOME}/squeak/run.sh" # get_vm_details

local config_smalltalk="${CONFIG_SMALLTALK}"
local config_vm_dir="${SMALLTALK_CI_VMS}/${config_smalltalk}"
local require_spur=1

local vm_details # not needed
local vm_filename # not needed
local vm_path
local git_tag # not needed

vm_details=$(squeak::get_vm_details \
	"${config_smalltalk}" "$(uname -s)" "${require_spur}")
set_vars vm_filename vm_path git_tag "${vm_details}"

LATEST_BUILD="https://github.com/OpenSmalltalk/opensmalltalk-vm/releases/latest-build"
WINDOWS_BUILD="${LATEST_BUILD}/squeak.cog.spur_win64x64.zip"
LINUX_BUILD="${{LATEST_BUILD}/squeak.cog.spur_linux64x64.tar.gz"
# MACOS_BUILD: "https://github.com/hpi-swa/smalltalkCI/releases/download/v2.9.6/squeak.cog.v3_macos32x86_202101260417.dmg"
MACOS_BUILD="${LATEST_BUILD}/squeak.cog.spur_macos64x64.dmg"

case $RUNNER_OS in
	"Windows")
		local download_url="${WINDOWS_BUILD}"
		local target="${SMALLTALK_CI_CACHE}/vm.zip"
		;;
	"Linux")
		local download_url="${LINUX_BUILD}"
		local target="${SMALLTALK_CI_CACHE}/vm.tar.gz"
		;;
	"macOS")
		local download_url="${MACOS_BUILD}"
		local target="${SMALLTALK_CI_CACHE}/vm.dmg"
		;;
esac

download_file "${download_url}" "${target}"

is_dir "${config_vm_dir}" || mkdir -p "${config_vm_dir}"
extract_file "${target}" "${config_vm_dir}"

chmod +x "${vm_path}"
if is_cygwin_build || is_mingw64_build; then
	chmod +x "$(dirname ${vm_path})/"*.dll
fi

echo "${VM_FILEPATH}=${vm_path}" >> $GITHUB_ENV
