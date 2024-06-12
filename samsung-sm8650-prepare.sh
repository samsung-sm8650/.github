#!/bin/bash

trap quit INT

[[ $1 = "--use-ssh" ]] && export USE_SSH=1

quit () {
	unset USE_SSH
	exit $1
}

error () {
	echo -e "\033[0;31mERROR:\033[0m $1"
	quit 1
}

note () {
	echo -e "\033[0;34mNOTE:\033[0m $1"
}

dl-src () {
	[[ $USE_SSH -eq 1 ]] &&
		git clone --branch $2 git@github.com:samsung-sm8650/$1.git $3 &&
		return ||
		git clone --branch $2 https://github.com/samsung-sm8650/$1.git $3 &&
		return

	error "Something went wrong while downloading git repositories."
}

# Check if we're indeed in the LineageOS source repository
[[ -d android ]] && [[ -d lineage ]] && [[ -f build/envsetup.sh ]] ||
	error "LineageOS source code not found. Please run this script from the root of the source code."

source build/envsetup.sh

# Pick the following patches from LineageOS Gerrit
# https://review.lineageos.org/c/LineageOS/android_hardware_qcom-caf_common/+/389365
# https://review.lineageos.org/c/LineageOS/android_vendor_lineage/+/394099
# https://review.lineageos.org/c/LineageOS/android/+/394100
repopick 389365 394099 394100

# Clone sm8650 HALs
[[ $USE_SSH -eq 1 ]] && note "Using SSH to clone git repositories." || note "Using HTTPS to clone git repositores."
dl-src android_device_qcom_sepolicy_vndr lineage-21.0-caf-sm8650 device/qcom/sepolicy_vndr/sm8650
dl-src android_device_samsung_e3q lineage-21 device/samsung/e3q
dl-src android_hardware_qcom_audio-ar lineage-21.0-caf-sm8650 hardware/qcom-caf/sm8650/audio/primary-hal
dl-src android_hardware_qcom_display lineage-21.0-caf-sm8650 hardware/qcom-caf/sm8650/display
dl-src android_hardware_qcom_media lineage-21.0-caf-sm8650 hardware/qcom-caf/sm8650/media
dl-src android_vendor_qcom_opensource_agm lineage-21.0-caf-sm8650 hardware/qcom-caf/sm8650/audio/agm
dl-src android_vendor_qcom_opensource_arpal-lx lineage-21.0-caf-sm8650 hardware/qcom-caf/sm8650/audio/pal
dl-src android_vendor_qcom_opensource_data-ipa-cfg-mgr lineage-21.0-caf-sm8650 hardware/qcom-caf/sm8650/data-ipa-cfg-mgr
dl-src android_vendor_qcom_opensource_dataipa lineage-21.0-caf-sm8650 hardware/qcom-caf/sm8650/dataipa

# Add necessary symlinks
ln -s ../../common/os_pickup_audio-ar.mk hardware/qcom-caf/sm8650/audio/Android.mk
ln -s ../common/os_pickup.mk hardware/qcom-caf/sm8650/Android.mk
ln -s ../common/os_pickup_qssi.bp hardware/qcom-caf/sm8650/Android.bp

quit 0
