#!/bin/bash
# 
# Copyright (C) 2020 RB INTERNATIONAL NETWORK
#
#            An Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

echo "<<<<< © RB INTERNATIONAL NETWORK™ >>>>>"

DEVICE_TREE=""
DEVICE_TREE_BRANCH=""
ROM_DIR=""

echo "Enter full rom directory"
echo "eg, /home/cyberjalagam/potato"
read ROM_DIR


echo "Enter Device tree link: "
read DEVICE_TREE

echo "Enter Device tree branch: "
read DEVICE_TREE_BRANCH

cd "$ROM_DIR"

# Device tree
echo -e "\n================== Clonning device tree ==================\n"
git clone "$DEVICE_TREE" -b "$DEVICE_TREE_BRANCH" device/realme/RMX1821

# Vendor Tree
echo -e "\n================== Clonning vendor tree ==================\n"
git clone https://github.com/RADEON7/android_vendor_realme_RMX1821.git vendor/realme/RMX1821

# Kernel Tree
echo -e "\n================== Clonning kernel tree ==================\n"
git clone https://github.com/RADEON7/android_kernel_realme_RMX1821.git kernel/realme/RMX1821
echo -e "\n Done!\n"

# Revert an selinux commit
echo -e "\n======================== SeFix ============================\n"
cd external/selinux
wget https://github.com/CyberJalagam/android_rom_building_scripts/raw/master/patches/Revert-libsepol:Make-an-unknown-permission-an-error-in-CIL.patch
git am Revert-"libsepol:Make-an-unknown-permission-an-error-in-CIL".patch 

cd ../..

# some really necessary patches for IMS to work
cd frameworks/base
wget https://github.com/CyberJalagam/android_rom_building_scripts/raw/master/patches/WifiManager:Add-StaState-API.patch
git am WifiManager:Add-StaState-API.patch

cd ../../


cd frameworks/opt/net/wifi
wget https://github.com/CyberJalagam/android_rom_building_scripts/raw/master/patches/wifi:Add-StaState-API.patch
git am wifi:Add-StaState-API.patch

cd ../ims
wget https://github.com/CyberJalagam/android_rom_building_scripts/raw/master/patches/Partially-Revert-Remove-references-to-deprecated-device.patch
git am Partially-Revert-Remove-references-to-deprecated-device.patch

cd ../../../..

cd system/core
wget https://raw.githubusercontent.com/RADEON7/android_device_realme_RMX1821/lineage-18.1-rmui/patches/system/core/0001-init-Weaken-property-override-security-for-the-init-.patch
git am 0001-init-Weaken-property-override-security-for-the-init-.patch

cd ../..

cd build/make

wget https://raw.githubusercontent.com/RADEON7/android_device_realme_RMX1821/lineage-18.1-rmui/patches/build/make/0001-build-Add-option-to-append-vbmeta-image-to-boot-imag.patch
git am 0001-build-Add-option-to-append-vbmeta-image-to-boot-imag.patch

cd ../..

rm -rf prebuilts/clang/host/linux-x86 && git clone https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86 -b android-11.0.0_r31 prebuilts/clang/host/linux-x86

echo "<<<<< © RB INTERNATIONAL NETWORK™ >>>>>"
