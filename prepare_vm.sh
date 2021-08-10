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
