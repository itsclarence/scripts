#!/bin/bash
#
# RAGHU VARMA Build Script 
# Coded by RV 
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

clear

# Detail Versions

path=/var/lib/jenkins/workspace/Raghu
securitypatch=2020-04-05
tag=4.4.194
jenkinsurl=


# credentials

Telegram_Api_code=$(cat $path/cred** | grep api | cut -d "=" -f 2)
chat_id=$(cat $path/cred** | grep id | cut -d "=" -f 2)
password=$(cat $path/cred** | grep sf | cut -d "=" -f 2)
gitpassword=$(cat $path/cred** | grep git | cut -d "=" -f 2)


# Init Methods

LINEAGE-SOURCE()
{
    git clone https://$gitpassword@github.com/RaghuVarma331/Keys keys
    wget  https://github.com/RaghuVarma331/scripts/raw/master/pythonscripts/telegram.py
    wget https://github.com/RaghuVarma331/custom_roms_banners/raw/master/lineage.jpg
    wget https://raw.githubusercontent.com/RaghuVarma331/changelogs/master/crossdevelopment/changelog.txt
    wget https://github.com/RaghuVarma331/changelogs/raw/master/crossdevelopment/whyred.txt
    git clone https://$gitpassword@github.com/RaghuVarma331/Json-Tracker.git json
    git clone https://github.com/RaghuVarma331/prebuilt_kernels.git -b ten prebuilts
    mkdir los
    cd los
    echo -ne '\n' | repo init -u git://github.com/LineageOS/android.git -b lineage-17.1 --depth=1
    repo sync -c --no-tags --no-clone-bundle -f --force-sync -j16
    sed -i "/ro.control_privapp_permissions=enforce/d" vendor/lineage/config/common.mk
    rm -r device/lineage/sepolicy
    rm -r packages/apps/Settings
    rm -r packages/apps/Updater    
    rm -r system/sepolicy
    git clone https://github.com/LineageOS/android_system_sepolicy.git -b lineage-17.1 system/sepolicy 
    cd system/sepolicy 
    git remote add ss https://github.com/RaghuVarma331/android_system_sepolicy.git 
    git fetch ss
    git cherry-pick 242d14d7274dc8aed7ae91d77365aee25910cbf6
    cd $path/los
    git clone https://github.com/RaghuVarma331/android_device_nokia_Dragon.git -b ten device/nokia/Dragon 
    git clone https://github.com/RaghuVarma331/android_kernel_nokia_sdm660.git -b ten-gcc --depth=1 kernel/nokia/sdm660
    git clone https://github.com/RaghuVarma331/android_vendor_nokia.git -b ten vendor/nokia
    git clone https://github.com/RaghuVarma331/vendor_nokia_Camera.git -b ten --depth=1 vendor/nokia/Camera
    git clone https://gitlab.com/RaghuVarma331/vendor_gapps.git -b ten --depth=1 vendor/gapps
    git clone https://github.com/RaghuVarma331/device_custom_sepolicy.git -b los-ten device/lineage/sepolicy
    git clone https://github.com/RaghuVarma331/Os_Updates.git -b pixel-ten packages/apps/Os_Updates    
    git clone https://github.com/LineageOS/android_packages_resources_devicesettings.git -b lineage-17.1 packages/resources/devicesettings
    git clone https://github.com/LineageOS/android_packages_apps_Settings.git -b lineage-17.1 packages/apps/Settings    
    cd packages/apps/Settings
    git remote add main https://github.com/RaghuVarma331/settings.git
    git fetch main
    git cherry-pick d0dede567168181d4f0035f61cf12f2996445be7
    git cherry-pick 249b4a08e10be19d20b9b25f88fcc6ee230a6614
    cd
    cd $path/los 
    cd packages/apps/Os_Updates/src/org/pixelexperience/ota/misc
    rm -r Constants.java
    wget https://github.com/RaghuVarma331/Json-configs/raw/master/Dragon/LineageOS/Constants.java
    cd
    cd $path/los
    curl -s -X POST https://api.telegram.org/bot$Telegram_Api_code/sendMessage -d chat_id=$chat_id -d text="
    
    New LineageOS 17.1 for Nokia 6.1 Plus build started 
    
    $(date)
    
    👤 By: Raghu Varma

    build's progress at $jenkinsurl"  
    export SELINUX_IGNORE_NEVERALLOWS=true
    . build/envsetup.sh && lunch lineage_Dragon-userdebug && make target-files-package otatools
    romname=$(cat $path/los/out/target/product/Dragon/system/build.prop | grep ro.lineage.version | cut -d "=" -f 2)
    ./build/tools/releasetools/sign_target_files_apks -o -d $path/keys $path/los/out/target/product/Dragon/obj/PACKAGING/target_files_intermediates/*-target_files-*.zip $path/los/out/target/product/Dragon/signed-target-files.zip
    ./build/tools/releasetools/ota_from_target_files -k $path/keys/releasekey $path/los/out/target/product/Dragon/signed-target-files.zip $path/los/out/target/product/Dragon/lineage-$romname.zip
    cd out/target/product/Dragon
    rm -r **.json
    wget https://github.com/RaghuVarma331/scripts/raw/master/Json_generator/drg_lineage.sh
    chmod a+x drg_lineage.sh
    ./drg_lineage.sh
    zipname=$(echo lineage-17.1**.zip)
    cat $zipname.json > $path/json/Dragon/lineage.json    
    sshpass -p $password rsync -avP -e ssh lineage-17.1**.zip     raghuvarma331@frs.sourceforge.net:/home/frs/project/drg-sprout/LineageOS
    cd 
    cd $path
    python telegram.py -t $Telegram_Api_code -c $chat_id  -P lineage.jpg -C "
    *
    New LineageOS 17.1 Build is up 
    
    $(date)*
    
    ⬇️ [Download Rom](https://forum.xda-developers.com/nokia-6-1-plus/development/beta-lineageos-17-0-t3985367)
    ⬇️ [Download Vendor](https://forum.xda-developers.com/nokia-6-1-plus/development/vendor-drg-drgsprout-treble-gsi-vendor-t4040201)
    💬 [Device Changelog](https://raw.githubusercontent.com/RaghuVarma331/changelogs/master/nokia.txt)
    💬 [Installation procedure](https://github.com/RaghuVarma331/changelogs/raw/master/crossdevelopment/abcrins.txt)
    📱Device: *Nokia 6.1 Plus*
    ⚡Build Version: *17.1* 
    ⚡Android Version: *10.0.0*
    ⚡Security Patch : *$securitypatch*
    👤 By: *Raghu Varma*
    #drg #nokia #los #update
    Follow:  @Nokia6plusofficial ✅"  
    cd json
    git add .
    git commit -m "Dragon: LineageOS 17.1 build $(date)"
    git push -u -f origin master
    cd ..    
    cd los
    rm -r device/nokia
    rm -r out/target/product/**
    git clone https://github.com/RaghuVarma331/android_device_nokia_Onyx.git -b ten device/nokia/Onyx   
    cd packages/apps/Os_Updates/src/org/pixelexperience/ota/misc
    rm -r Constants.java
    wget https://github.com/RaghuVarma331/Json-configs/raw/master/Onyx/LineageOS/Constants.java
    cd
    cd $path/los    
    curl -s -X POST https://api.telegram.org/bot$Telegram_Api_code/sendMessage -d chat_id=$chat_id -d text="
    
    New LineageOS 17.1 for Nokia 7 Plus build started 
    
    $(date)
    
    👤 By: Raghu Varma

    build's progress at $jenkinsurl"      
    export SELINUX_IGNORE_NEVERALLOWS=true
    . build/envsetup.sh && lunch lineage_Onyx-userdebug && make target-files-package otatools
    romname=$(cat $path/los/out/target/product/Onyx/system/build.prop | grep ro.lineage.version | cut -d "=" -f 2)
    ./build/tools/releasetools/sign_target_files_apks -o -d $path/keys $path/los/out/target/product/Onyx/obj/PACKAGING/target_files_intermediates/*-target_files-*.zip $path/los/out/target/product/Onyx/signed-target-files.zip
    ./build/tools/releasetools/ota_from_target_files -k $path/keys/releasekey $path/los/out/target/product/Onyx/signed-target-files.zip $path/los/out/target/product/Onyx/lineage-$romname.zip
    cd out/target/product/Onyx
    rm -r **.json      
    wget https://github.com/RaghuVarma331/scripts/raw/master/Json_generator/b2n_lineage.sh
    chmod a+x b2n_lineage.sh
    ./b2n_lineage.sh
    zipname=$(echo lineage-17.1**.zip)
    cat $zipname.json > $path/json/Onyx/lineage.json        
    sshpass -p $password rsync -avP -e ssh lineage-17.1**.zip     raghuvarma331@frs.sourceforge.net:/home/frs/project/b2n-sprout/LineageOS
    cd 
    cd $path
    python telegram.py -t $Telegram_Api_code -c $chat_id  -P lineage.jpg -C "
    *
    New LineageOS 17.1 Build is up 
    
    $(date)*
    
    ⬇️ [Download ROM](https://forum.xda-developers.com/nokia-7-plus/development/rom-lineageos-17-0-t3993445)
    ⬇️ [Download Vendor](https://forum.xda-developers.com/nokia-7-plus/development/vendor-b2n-b2nsprout-treble-gsi-vendor-t4040207)
    💬 [Device Changelog](https://raw.githubusercontent.com/RaghuVarma331/changelogs/master/nokia.txt)
    💬 [Installation procedure](https://github.com/RaghuVarma331/changelogs/raw/master/crossdevelopment/abcrins.txt)
    📱Device: *Nokia 7 Plus*
    ⚡Build Version: *17.1*
    ⚡Android Version: *10.0.0*
    ⚡Security Patch : *$securitypatch*
    👤 By: *Raghu Varma*
    #b2n #nokia #los #update
    Follow: @Nokia7plusOfficial ✅"    
    cd json
    git add .
    git commit -m "Onyx: LineageOS 17.1 build $(date)"
    git push -u -f origin master
    cd ..    
    cd los
    rm -r device/nokia
    rm -r out/target/product/**
    git clone https://github.com/RaghuVarma331/android_device_nokia_Crystal.git -b ten device/nokia/Crystal   
    cd packages/apps/Os_Updates/src/org/pixelexperience/ota/misc
    rm -r Constants.java
    wget https://github.com/RaghuVarma331/Json-configs/raw/master/Crystal/LineageOS/Constants.java
    cd
    cd $path/los    
    curl -s -X POST https://api.telegram.org/bot$Telegram_Api_code/sendMessage -d chat_id=$chat_id -d text="
    
    New LineageOS 17.1 for Nokia 7.1 build started 
    
    $(date)
    
    👤 By: Raghu Varma

    build's progress at $jenkinsurl"    
    export SELINUX_IGNORE_NEVERALLOWS=true
    . build/envsetup.sh && lunch lineage_Crystal-userdebug && make target-files-package otatools
    romname=$(cat $path/los/out/target/product/Crystal/system/build.prop | grep ro.lineage.version | cut -d "=" -f 2)
    ./build/tools/releasetools/sign_target_files_apks -o -d $path/keys $path/los/out/target/product/Crystal/obj/PACKAGING/target_files_intermediates/*-target_files-*.zip $path/los/out/target/product/Crystal/signed-target-files.zip
    ./build/tools/releasetools/ota_from_target_files -k $path/keys/releasekey $path/los/out/target/product/Crystal/signed-target-files.zip $path/los/out/target/product/Crystal/lineage-$romname.zip
    cd out/target/product/Crystal
    rm -r **.json
    wget https://github.com/RaghuVarma331/scripts/raw/master/Json_generator/ctl_lineage.sh
    chmod a+x ctl_lineage.sh
    ./ctl_lineage.sh
    zipname=$(echo lineage-17.1**.zip)
    cat $zipname.json > $path/json/Crystal/lineage.json      
    sshpass -p $password rsync -avP -e ssh lineage-17.1**.zip     raghuvarma331@frs.sourceforge.net:/home/frs/project/ctl-sprout/LineageOS
    cd 
    cd $path
    python telegram.py -t $Telegram_Api_code -c $chat_id  -P lineage.jpg -C "
    *
    New LineageOS 17.1 Build is up 
    
    $(date)*
    
    ⬇️ [Download ROM](https://forum.xda-developers.com/nokia-7-1/development/rom-lineageos-17-0-t4019915)
    ⬇️ [Download Vendor](https://forum.xda-developers.com/nokia-7-1/development/vendor-ctl-ctlsprout-treble-gsi-vendor-t4040211)
    💬 [Device Changelog](https://raw.githubusercontent.com/RaghuVarma331/changelogs/master/nokia.txt)
    💬 [Installation procedure](https://github.com/RaghuVarma331/changelogs/raw/master/crossdevelopment/abcrins.txt)
    📱Device: *Nokia 7.1*
    ⚡Build Version: *17.1*
    ⚡Android Version: *10.0.0*
    ⚡Security Patch : *$securitypatch*
    👤 By: *Raghu Varma*
    #ctl #nokia #los #update
    Follow: @nokia7161  ✅"     
    cd json
    git add .
    git commit -m "Crystal: LineageOS 17.1 build $(date)"
    git push -u -f origin master
    cd ..      
    cd los
    rm -r device/nokia
    rm -r out/target/product/**
    git clone https://github.com/RaghuVarma331/android_device_nokia_Daredevil.git -b ten device/nokia/Daredevil 
    cd packages/apps/Os_Updates/src/org/pixelexperience/ota/misc
    rm -r Constants.java
    wget https://github.com/RaghuVarma331/Json-configs/raw/master/Daredevil/LineageOS/Constants.java
    cd
    cd $path/los
    cd vendor/lineage/build/tasks
    rm -r kernel.mk
    wget https://github.com/RaghuVarma331/vendor_custom/raw/ten-los/build/tasks/kernel.mk
    cd
    cd $path/los    
    curl -s -X POST https://api.telegram.org/bot$Telegram_Api_code/sendMessage -d chat_id=$chat_id -d text="
    
    New LineageOS 17.1 for Nokia 7.2 build started 
    
    $(date)
    
    👤 By: Raghu Varma

    build's progress at $jenkinsurl"     
    export SELINUX_IGNORE_NEVERALLOWS=true
    . build/envsetup.sh && lunch lineage_Daredevil-userdebug && make target-files-package otatools
    romname=$(cat $path/los/out/target/product/Daredevil/system/build.prop | grep ro.lineage.version | cut -d "=" -f 2)
    ./build/tools/releasetools/sign_target_files_apks -o -d $path/keys $path/los/out/target/product/Daredevil/obj/PACKAGING/target_files_intermediates/*-target_files-*.zip $path/los/out/target/product/Daredevil/signed-target-files.zip
    ./build/tools/releasetools/ota_from_target_files -k $path/keys/releasekey $path/los/out/target/product/Daredevil/signed-target-files.zip $path/los/out/target/product/Daredevil/lineage-$romname.zip
    cd out/target/product/Daredevil
    rm -r **.json
    wget https://github.com/RaghuVarma331/scripts/raw/master/Json_generator/ddv_lineage.sh
    chmod a+x ddv_lineage.sh
    ./ddv_lineage.sh
    zipname=$(echo lineage-17.1**.zip)
    cat $zipname.json > $path/json/Daredevil/lineage.json      
    sshpass -p $password rsync -avP -e ssh lineage-17.1**.zip     raghuvarma331@frs.sourceforge.net:/home/frs/project/ddv-sprout/LineageOS
    cd 
    cd $path
    python telegram.py -t $Telegram_Api_code -c $chat_id  -P lineage.jpg -C "
    *
    New LineageOS 17.1 Build is up 
    
    $(date)*
    
    ⬇️ [Download ROM](https://forum.xda-developers.com/nokia-7-2/development/rom-lineageos-17-0-t4001281)
    ⬇️ [Download Vendor](https://forum.xda-developers.com/nokia-7-2/development/vendor-ddv-ddvsprout-treble-gsi-vendor-t4083095)
    💬 [Device Changelog](https://raw.githubusercontent.com/RaghuVarma331/changelogs/master/nokia.txt)
    💬 [Installation procedure](https://github.com/RaghuVarma331/changelogs/raw/master/crossdevelopment/abcrins.txt)
    📱Device: *Nokia 7.2*
    ⚡Build Version: *17.1*
    ⚡Android Version: *10.0.0*
    ⚡Security Patch : *$securitypatch*
    👤 By: *Raghu Varma*
    #ddv #nokia #los #update
    Follow: @Nokia7262  ✅"     
    cd json
    git add .
    git commit -m "Daredevil: LineageOS 17.1 build $(date)"
    git push -u -f origin master
    cd ..      
    cd los    
    rm -r device/nokia
    rm -r kernel/nokia
    rm -r vendor/nokia 
    rm -r vendor/gapps
    rm -r out/target/product/**
    rm -r device/lineage/sepolicy
    git clone https://github.com/LineageOS/android_device_lineage_sepolicy.git -b lineage-17.1 device/lineage/sepolicy
    cd device/lineage/sepolicy
    git remote add ls https://github.com/RaghuVarma331/device_custom_sepolicy
    git fetch ls
    git cherry-pick 126467d47adbcca911ac54957c89dcfd5d3b0f50
    cd $path/los
    git clone https://github.com/RaghuVarma331/android_device_xiaomi_whyred.git -b lineage-17.1 device/xiaomi/whyred
    git clone https://github.com/RaghuVarma331/android_kernel_xiaomi_whyred.git -b lineage-17.1 --depth=1 kernel/xiaomi/whyred
    git clone https://github.com/RaghuVarma331/vendor_xiaomi_whyred.git -b lineage-17.1 vendor/xiaomi/whyred
    cd packages/apps/Os_Updates/src/org/pixelexperience/ota/misc
    rm -r Constants.java
    wget https://raw.githubusercontent.com/RaghuVarma331/Json-configs/master/whyred/LineageOS/Constants.java
    cd
    cd $path/los
    cd vendor/lineage/build/tasks
    rm -r kernel.mk
    wget https://github.com/LineageOS/android_vendor_lineage/raw/lineage-17.1/build/tasks/kernel.mk
    cd
    cd $path/los          
    curl -s -X POST https://api.telegram.org/bot$Telegram_Api_code/sendMessage -d chat_id=$chat_id -d text="
    
    New LineageOS 17.1 for Redmi Note 5 Pro build started 
    
    $(date)
    
    👤 By: Raghu Varma
    build's progress at $jenkinsurl"    
    . build/envsetup.sh && lunch lineage_whyred-userdebug && make target-files-package otatools
    romname=$(cat $path/los/out/target/product/whyred/system/build.prop | grep ro.lineage.version | cut -d "=" -f 2)
    ./build/tools/releasetools/sign_target_files_apks -o -d $path/keys $path/los/out/target/product/whyred/obj/PACKAGING/target_files_intermediates/*-target_files-*.zip $path/los/out/target/product/whyred/signed-target-files.zip
    ./build/tools/releasetools/ota_from_target_files -k $path/keys/releasekey $path/los/out/target/product/whyred/signed-target-files.zip $path/los/out/target/product/whyred/lineage-$romname.zip
    cd out/target/product/whyred
    rm -r **.json  
    wget https://github.com/RaghuVarma331/scripts/raw/master/Json_generator/whyred_lineage.sh
    chmod a+x whyred_lineage.sh
    ./whyred_lineage.sh
    zipname=$(echo lineage-17.1**.zip)
    cat $zipname.json > $path/json/whyred/lineage.json       
    sshpass -p $password rsync -avP -e ssh lineage-17.1**.zip     raghuvarma331@frs.sourceforge.net:/home/frs/project/whyred-rv/LineageOS
    cd 
    cd $path
    rm -r los
    python telegram.py -t $Telegram_Api_code -c $chat_id  -P lineage.jpg -C "
    *
    New LineageOS 17.1 Build is up 
    
    $(date)*
    
    ⬇️ [Download ROM](https://forum.xda-developers.com/redmi-note-5-pro/development/rom-lineageos-16-0-t3882431)
    💬 [Device Changelog](https://raw.githubusercontent.com/RaghuVarma331/changelogs/master/whyred.txt)
    📱Device: *Redmi Note 5 Pro*
    ⚡Build Version: *17.1*
    ⚡Android Version: *10.0.0*
    ⚡Security Patch : *$securitypatch*
    👤 By: *Raghu Varma*
    #whyred #nokia #los #update
    Follow: @whyredrn5pro ✅"      
    cd json
    git add .
    git commit -m "Whyred: LineageOS 17.1 build $(date)"
    git push -u -f origin master
    cd ..        
}

PE-SOURCE()
{
    git clone https://$gitpassword@github.com/RaghuVarma331/Keys keys
    wget  https://github.com/RaghuVarma331/scripts/raw/master/pythonscripts/telegram.py
    wget https://github.com/RaghuVarma331/custom_roms_banners/raw/master/pixel.jpg
    wget https://raw.githubusercontent.com/RaghuVarma331/changelogs/master/crossdevelopment/changelog.txt
    git clone https://$gitpassword@github.com/RaghuVarma331/Json-Tracker.git json
    git clone https://github.com/RaghuVarma331/prebuilt_kernels.git -b ten prebuilts    
    mkdir pe
    cd pe
    echo -ne '\n' | repo init -u https://github.com/PixelExperience/manifest -b ten --depth=1
    repo sync -c --no-tags --no-clone-bundle -f --force-sync -j16
    sed -i "/ro.control_privapp_permissions=enforce/d" vendor/aosp/config/common.mk
    rm -r packages/apps/Gallery2
    rm -r vendor/gapps
    rm -r packages/apps/Settings
    rm -r packages/apps/Updates
    rm -r device/custom/sepolicy   
    rm -r system/sepolicy
    git clone https://github.com/PixelExperience/system_sepolicy.git -b ten system/sepolicy
    cd system/sepolicy
    git remote add ss https://github.com/RaghuVarma331/android_system_sepolicy.git 
    git fetch ss
    git cherry-pick 242d14d7274dc8aed7ae91d77365aee25910cbf6  
    cd $path/pe
    git clone https://github.com/RaghuVarma331/android_device_nokia_Dragon.git -b ten device/nokia/Dragon 
    git clone https://github.com/RaghuVarma331/android_kernel_nokia_sdm660.git -b ten-gcc --depth=1 kernel/nokia/sdm660
    git clone https://github.com/RaghuVarma331/android_vendor_nokia.git -b ten vendor/nokia
    git clone https://github.com/RaghuVarma331/vendor_nokia_Camera.git -b ten --depth=1 vendor/nokia/Camera
    git clone https://gitlab.com/RaghuVarma331/vendor_gapps.git -b ten --depth=1 vendor/gapps
    git clone https://github.com/RaghuVarma331/device_custom_sepolicy.git -b pe-ten device/custom/sepolicy
    git clone https://github.com/RaghuVarma331/android_packages_apps_Gallery2.git -b lineage-17.1 packages/apps/Gallery2
    git clone https://github.com/RaghuVarma331/Os_Updates.git -b pixel-ten packages/apps/Os_Updates          
    git clone https://github.com/LineageOS/android_packages_resources_devicesettings.git -b lineage-17.1 packages/resources/devicesettings
    git clone https://github.com/PixelExperience/packages_apps_Settings.git -b ten packages/apps/Settings    
    cd packages/apps/Settings    
    git remote add main https://github.com/RaghuVarma331/settings.git
    git fetch main
    git cherry-pick d0dede567168181d4f0035f61cf12f2996445be7
    git cherry-pick 249b4a08e10be19d20b9b25f88fcc6ee230a6614
    cd src/com/android/settings/system
    rm -r SystemUpdatePreferenceController.java
    wget https://raw.githubusercontent.com/RaghuVarma331/settings/ten/src/com/android/settings/system/SystemUpdatePreferenceController.java
    cd
    cd $path/pe    
    cd packages/apps/Os_Updates/src/org/pixelexperience/ota/misc
    rm -r Constants.java
    wget https://github.com/RaghuVarma331/Json-configs/raw/master/Dragon/PixelExperience/Constants.java
    cd
    cd $path/pe   
    curl -s -X POST https://api.telegram.org/bot$Telegram_Api_code/sendMessage -d chat_id=$chat_id -d text="
    
    New Pixel-Experience for Nokia 6.1 Plus build started 
    
    $(date)
    
    👤 By: Raghu Varma

    build's progress at $jenkinsurl"      
    export SELINUX_IGNORE_NEVERALLOWS=true
    . build/envsetup.sh && lunch aosp_Dragon-userdebug && make target-files-package otatools
    romname=$(cat $path/pe/out/target/product/Dragon/system/build.prop | grep org.pixelexperience.version.display | cut -d "=" -f 2)
    ./build/tools/releasetools/sign_target_files_apks -o -d $path/keys $path/pe/out/target/product/Dragon/obj/PACKAGING/target_files_intermediates/*-target_files-*.zip $path/pe/out/target/product/Dragon/signed-target-files.zip
    ./build/tools/releasetools/ota_from_target_files -k $path/keys/releasekey $path/pe/out/target/product/Dragon/signed-target-files.zip $path/pe/out/target/product/Dragon/$romname.zip
    cd out/target/product/Dragon
    rm -r **.json
    wget https://github.com/RaghuVarma331/scripts/raw/master/Json_generator/drg_pe.sh
    chmod a+x drg_pe.sh
    ./drg_pe.sh
    zipname=$(echo PixelExperience**.zip)
    cat $zipname.json > $path/json/Dragon/pixel.json       
    sshpass -p $password rsync -avP -e ssh PixelExperience**.zip     raghuvarma331@frs.sourceforge.net:/home/frs/project/drg-sprout/PixelExperience
    cd 
    cd $path
    python telegram.py -t $Telegram_Api_code -c $chat_id  -P pixel.jpg -C "
    *
    New Pixel-Experience Build is up 
    
    $(date)*
    
    ⬇️ [Download ROM](https://forum.xda-developers.com/nokia-6-1-plus/development/rom-pixel-experience-t3985853)
    ⬇️ [Download Vendor](https://forum.xda-developers.com/nokia-6-1-plus/development/vendor-drg-drgsprout-treble-gsi-vendor-t4040201)
    💬 [Device Changelog](https://raw.githubusercontent.com/RaghuVarma331/changelogs/master/nokia.txt)
    💬 [Installation procedure](https://github.com/RaghuVarma331/changelogs/raw/master/crossdevelopment/abcrins.txt)
    📱Device: *Nokia 6.1 Plus*
    ⚡Build Version: *Ten*
    ⚡Android Version: *10.0.0*
    ⚡Security Patch : *$securitypatch*
    👤 By: *Raghu Varma*
    #drg #nokia #pe #update
    Follow:  @Nokia6plusofficial ✅" 
    cd json
    git add .
    git commit -m "Dragon: PixelExperience 10.0 build $(date)"
    git push -u -f origin master
    cd ..        
    cd pe
    rm -r device/nokia
    rm -r out/target/product/**
    git clone https://github.com/RaghuVarma331/android_device_nokia_Onyx.git -b ten device/nokia/Onyx 
    cd packages/apps/Os_Updates/src/org/pixelexperience/ota/misc
    rm -r Constants.java
    wget https://github.com/RaghuVarma331/Json-configs/raw/master/Onyx/PixelExperience/Constants.java
    cd
    cd $path/pe    
    curl -s -X POST https://api.telegram.org/bot$Telegram_Api_code/sendMessage -d chat_id=$chat_id -d text="
    
    New Pixel-Experience for Nokia 7 Plus build started 
    
    $(date)
    
    👤 By: Raghu Varma

    build's progress at $jenkinsurl"      
    export SELINUX_IGNORE_NEVERALLOWS=true
    . build/envsetup.sh && lunch aosp_Onyx-userdebug && make target-files-package otatools
    romname=$(cat $path/pe/out/target/product/Onyx/system/build.prop | grep org.pixelexperience.version.display | cut -d "=" -f 2)
    ./build/tools/releasetools/sign_target_files_apks -o -d $path/keys $path/pe/out/target/product/Onyx/obj/PACKAGING/target_files_intermediates/*-target_files-*.zip $path/pe/out/target/product/Onyx/signed-target-files.zip
    ./build/tools/releasetools/ota_from_target_files -k $path/keys/releasekey $path/pe/out/target/product/Onyx/signed-target-files.zip $path/pe/out/target/product/Onyx/$romname.zip
    cd out/target/product/Onyx
    rm -r **.json
    wget https://github.com/RaghuVarma331/scripts/raw/master/Json_generator/b2n_pe.sh
    chmod a+x b2n_pe.sh
    ./b2n_pe.sh
    zipname=$(echo PixelExperience**.zip)
    cat $zipname.json > $path/json/Onyx/pixel.json      
    sshpass -p $password rsync -avP -e ssh PixelExperience**.zip     raghuvarma331@frs.sourceforge.net:/home/frs/project/b2n-sprout/PixelExperience
    cd 
    cd $path
    python telegram.py -t $Telegram_Api_code -c $chat_id  -P pixel.jpg -C "
    *
    New Pixel-Experience Build is up 
    
    $(date)*
     
    ⬇️ [Download ROM](https://forum.xda-developers.com/nokia-7-plus/development/rom-pixel-experience-t3992063)
    ⬇️ [Download Vendor](https://forum.xda-developers.com/nokia-7-plus/development/vendor-b2n-b2nsprout-treble-gsi-vendor-t4040207)
    💬 [Device Changelog](https://raw.githubusercontent.com/RaghuVarma331/changelogs/master/nokia.txt)
    💬 [Installation procedure](https://github.com/RaghuVarma331/changelogs/raw/master/crossdevelopment/abcrins.txt)
    📱Device: *Nokia 7 Plus*
    ⚡Build Version: *Ten*
    ⚡Android Version: *10.0.0*
    ⚡Security Patch : *$securitypatch*
    👤 By: *Raghu Varma*
    #b2n #nokia #pe #update
    Follow: @Nokia7plusOfficial ✅"        
    cd json
    git add .
    git commit -m "Onyx: PixelExperience 10.0 build $(date)"
    git push -u -f origin master
    cd ..     
    cd pe
    rm -r device/nokia
    rm -r out/target/product/**
    git clone https://github.com/RaghuVarma331/android_device_nokia_Crystal.git -b ten device/nokia/Crystal 
    cd packages/apps/Os_Updates/src/org/pixelexperience/ota/misc
    rm -r Constants.java
    wget https://github.com/RaghuVarma331/Json-configs/raw/master/Crystal/PixelExperience/Constants.java
    cd
    cd $path/pe    
    curl -s -X POST https://api.telegram.org/bot$Telegram_Api_code/sendMessage -d chat_id=$chat_id -d text="
    
    New Pixel-Experience for Nokia 7.1 build started 
    
    $(date)
    
    👤 By: Raghu Varma

    build's progress at $jenkinsurl"      
    export SELINUX_IGNORE_NEVERALLOWS=true
    . build/envsetup.sh && lunch aosp_Crystal-userdebug && make target-files-package otatools
    romname=$(cat $path/pe/out/target/product/Crystal/system/build.prop | grep org.pixelexperience.version.display | cut -d "=" -f 2)
    ./build/tools/releasetools/sign_target_files_apks -o -d $path/keys $path/pe/out/target/product/Crystal/obj/PACKAGING/target_files_intermediates/*-target_files-*.zip $path/pe/out/target/product/Crystal/signed-target-files.zip
    ./build/tools/releasetools/ota_from_target_files -k $path/keys/releasekey $path/pe/out/target/product/Crystal/signed-target-files.zip $path/pe/out/target/product/Crystal/$romname.zip
    cd out/target/product/Crystal
    rm -r **.json
    wget https://github.com/RaghuVarma331/scripts/raw/master/Json_generator/ctl_pe.sh
    chmod a+x ctl_pe.sh
    ./ctl_pe.sh
    zipname=$(echo PixelExperience**.zip)
    cat $zipname.json > $path/json/Crystal/pixel.json     
    sshpass -p $password rsync -avP -e ssh PixelExperience**.zip     raghuvarma331@frs.sourceforge.net:/home/frs/project/ctl-sprout/PixelExperience
    cd 
    cd $path
    python telegram.py -t $Telegram_Api_code -c $chat_id  -P pixel.jpg -C "
    *
    New Pixel-Experience Build is up 
    
    $(date)*
     
    ⬇️ [Download ROM](https://forum.xda-developers.com/nokia-7-1/development/rom-pixel-experience-t4019933)
    ⬇️ [Download Vendor](https://forum.xda-developers.com/nokia-7-1/development/vendor-ctl-ctlsprout-treble-gsi-vendor-t4040211)
    💬 [Device Changelog](https://raw.githubusercontent.com/RaghuVarma331/changelogs/master/nokia.txt)
    💬 [Installation procedure](https://github.com/RaghuVarma331/changelogs/raw/master/crossdevelopment/abcrins.txt)
    📱Device: *Nokia 7.1*
    ⚡Build Version: *Ten*
    ⚡Android Version: *10.0.0*
    ⚡Security Patch : *$securitypatch*
    👤 By: *Raghu Varma*
    #ctl #nokia #pe #update
    Follow: @nokia7161 ✅"     
    cd json
    git add .
    git commit -m "Crystal: PixelExperience 10.0 build $(date)"
    git push -u -f origin master
    cd 
    cd $path
    cd pe
    rm -r device/nokia
    rm -r out/target/product/**
    git clone https://github.com/RaghuVarma331/android_device_nokia_Daredevil.git -b ten device/nokia/Daredevil
    cd packages/apps/Os_Updates/src/org/pixelexperience/ota/misc
    rm -r Constants.java
    wget https://github.com/RaghuVarma331/Json-configs/raw/master/Daredevil/PixelExperience/Constants.java
    cd
    cd $path/pe
    cd vendor/aosp/build/tasks
    rm -r kernel.mk
    wget https://github.com/RaghuVarma331/vendor_custom/raw/ten-los/build/tasks/kernel.mk
    cd
    cd $path/pe    
    curl -s -X POST https://api.telegram.org/bot$Telegram_Api_code/sendMessage -d chat_id=$chat_id -d text="
    
    New Pixel-Experience for Nokia 7.2 build started 
    
    $(date)
    
    👤 By: Raghu Varma

    build's progress at $jenkinsurl"  
    export SELINUX_IGNORE_NEVERALLOWS=true
    . build/envsetup.sh && lunch aosp_Daredevil-userdebug && make target-files-package otatools
    romname=$(cat $path/pe/out/target/product/Daredevil/system/build.prop | grep org.pixelexperience.version.display | cut -d "=" -f 2)
    ./build/tools/releasetools/sign_target_files_apks -o -d $path/keys $path/pe/out/target/product/Daredevil/obj/PACKAGING/target_files_intermediates/*-target_files-*.zip $path/pe/out/target/product/Daredevil/signed-target-files.zip
    ./build/tools/releasetools/ota_from_target_files -k $path/keys/releasekey $path/pe/out/target/product/Daredevil/signed-target-files.zip $path/pe/out/target/product/Daredevil/$romname.zip
    cd out/target/product/Daredevil
    rm -r **.json
    wget https://github.com/RaghuVarma331/scripts/raw/master/Json_generator/ddv_pe.sh
    chmod a+x ddv_pe.sh
    ./ddv_pe.sh
    zipname=$(echo PixelExperience**.zip)
    cat $zipname.json > $path/json/Daredevil/pixel.json     
    sshpass -p $password rsync -avP -e ssh PixelExperience**.zip     raghuvarma331@frs.sourceforge.net:/home/frs/project/ddv-sprout/PixelExperience
    cd 
    cd $path
    python telegram.py -t $Telegram_Api_code -c $chat_id  -P pixel.jpg -C "
    *
    New Pixel-Experience Build is up 
    
    $(date)*
     
    ⬇️ [Download ROM](https://forum.xda-developers.com/nokia-7-2/development/rom-pixel-experience-t4077103)
    ⬇️ [Download Vendor](https://forum.xda-developers.com/nokia-7-2/development/vendor-ddv-ddvsprout-treble-gsi-vendor-t4083095)
    💬 [Device Changelog](https://raw.githubusercontent.com/RaghuVarma331/changelogs/master/nokia.txt)
    💬 [Installation procedure](https://github.com/RaghuVarma331/changelogs/raw/master/crossdevelopment/abcrins.txt)
    📱Device: *Nokia 7.2*
    ⚡Build Version: *Ten*
    ⚡Android Version: *10.0.0*
    ⚡Security Patch : *$securitypatch*
    👤 By: *Raghu Varma*
    #ddv #nokia #pe #update
    Follow: @Nokia7262 ✅"     
    cd json
    git add .
    git commit -m "Daredevil: PixelExperience 10.0 build $(date)"
    git push -u -f origin master
    cd 
    cd $path
    rm -r pe    
}

DERP-SOURCE()
{
    git clone https://$gitpassword@github.com/RaghuVarma331/Keys keys
    wget  https://github.com/RaghuVarma331/scripts/raw/master/pythonscripts/telegram.py
    wget https://github.com/RaghuVarma331/custom_roms_banners/raw/master/derp.jpg
    wget https://raw.githubusercontent.com/RaghuVarma331/changelogs/master/crossdevelopment/changelog.txt
    git clone https://$gitpassword@github.com/RaghuVarma331/Json-Tracker.git json
    git clone https://github.com/RaghuVarma331/prebuilt_kernels.git -b ten prebuilts    
    mkdir derp
    cd derp
    echo -ne '\n' | repo init -u git://github.com/DerpLab/platform_manifest.git -b ten --depth=1
    repo sync -c --no-tags --no-clone-bundle -f --force-sync -j16
    sed -i "/ro.control_privapp_permissions=enforce/d" vendor/aosip/config/common.mk
    rm -r packages/apps/Gallery2
    rm -r vendor/gapps
    rm -r packages/apps/Settings
    rm -r packages/apps/OpenDelta  
    git clone https://github.com/RaghuVarma331/android_device_nokia_Dragon.git -b ten device/nokia/Dragon 
    git clone https://github.com/RaghuVarma331/android_kernel_nokia_sdm660.git -b ten-gcc --depth=1 kernel/nokia/sdm660
    git clone https://github.com/RaghuVarma331/android_vendor_nokia.git -b ten vendor/nokia
    git clone https://github.com/RaghuVarma331/vendor_nokia_Camera.git -b ten --depth=1 vendor/nokia/Camera
    git clone https://gitlab.com/RaghuVarma331/vendor_gapps.git -b ten --depth=1 vendor/gapps
    git clone https://github.com/RaghuVarma331/android_packages_apps_Gallery2.git -b lineage-17.1 packages/apps/Gallery2
    git clone https://github.com/RaghuVarma331/Os_Updates.git -b pixel-ten packages/apps/Os_Updates          
    git clone https://github.com/LineageOS/android_packages_resources_devicesettings.git -b lineage-17.1 packages/resources/devicesettings
    git clone https://github.com/DerpLab/platform_packages_apps_Settings.git -b ten packages/apps/Settings    
    cd packages/apps/Settings    
    git remote add main https://github.com/RaghuVarma331/settings.git
    git fetch main
    git cherry-pick 7e115712a20e3494a54cacc4ec71b982158e2af1
    git cherry-pick f997d458211f0f7a9c1d58be43b7a08327785287
    cd src/com/android/settings/system
    rm -r SystemUpdatePreferenceController.java
    wget https://raw.githubusercontent.com/RaghuVarma331/settings/ten/src/com/android/settings/system/SystemUpdatePreferenceController.java
    cd
    cd $path/derp    
    cd packages/apps/Os_Updates/src/org/pixelexperience/ota/misc
    rm -r Constants.java
    wget https://github.com/RaghuVarma331/Json-configs/raw/master/Dragon/DerpFest/Constants.java
    cd
    cd $path/derp   
    curl -s -X POST https://api.telegram.org/bot$Telegram_Api_code/sendMessage -d chat_id=$chat_id -d text="
    
    New DerpFest for Nokia 6.1 Plus build started 
    
    $(date)
    
    👤 By: Raghu Varma
    build's progress at $jenkinsurl"  
    export SELINUX_IGNORE_NEVERALLOWS=true
    . build/envsetup.sh && lunch derp_Dragon-userdebug && make target-files-package otatools
    romname=$(cat $path/derp/out/target/product/Dragon/system/etc/prop.default | grep ro.aosip.version | cut -d "=" -f 2)
    ./build/tools/releasetools/sign_target_files_apks -o -d $path/keys $path/derp/out/target/product/Dragon/obj/PACKAGING/target_files_intermediates/*-target_files-*.zip $path/derp/out/target/product/Dragon/signed-target-files.zip
    ./build/tools/releasetools/ota_from_target_files -k $path/keys/releasekey $path/derp/out/target/product/Dragon/signed-target-files.zip $path/derp/out/target/product/Dragon/DerpFest-$romname.zip
    cd out/target/product/Dragon
    rm -r **.json
    wget https://github.com/RaghuVarma331/scripts/raw/master/Json_generator/drg_derp.sh
    chmod a+x drg_derp.sh
    ./drg_derp.sh
    zipname=$(echo DerpFest**.zip)
    cat $zipname.json > $path/json/Dragon/derp.json       
    sshpass -p $password rsync -avP -e ssh DerpFest**.zip     raghuvarma331@frs.sourceforge.net:/home/frs/project/drg-sprout/DerpFest
    cd 
    cd $path
    python telegram.py -t $Telegram_Api_code -c $chat_id  -P derp.jpg -C "
    *
    New DerpFest Build is up 
    
    $(date)*
    
    ⬇️ [Download ROM](https://forum.xda-developers.com/nokia-6-1-plus/development/rom-aosip-derpfest-t4084447)
    ⬇️ [Download Vendor](https://forum.xda-developers.com/nokia-6-1-plus/development/vendor-drg-drgsprout-treble-gsi-vendor-t4040201)
    💬 [Device Changelog](https://raw.githubusercontent.com/RaghuVarma331/changelogs/master/nokia.txt)
    💬 [Installation procedure](https://github.com/RaghuVarma331/changelogs/raw/master/crossdevelopment/abcrins.txt)
    📱Device: *Nokia 6.1 Plus*
    ⚡Build Version: *Ten*
    ⚡Android Version: *10.0.0*
    ⚡Security Patch : *$securitypatch*
    👤 By: *Raghu Varma*
    #drg #nokia #derp #update
    Follow:  @Nokia6plusofficial ✅" 
    cd json
    git add .
    git commit -m "Dragon: DerpFest 10.0 build $(date)"
    git push -u -f origin master
    cd ..        
    cd derp
    rm -r device/nokia
    rm -r out/target/product/**
    git clone https://github.com/RaghuVarma331/android_device_nokia_Onyx.git -b ten device/nokia/Onyx 
    cd packages/apps/Os_Updates/src/org/pixelexperience/ota/misc
    rm -r Constants.java
    wget https://github.com/RaghuVarma331/Json-configs/raw/master/Onyx/DerpFest/Constants.java
    cd
    cd $path/derp  
    curl -s -X POST https://api.telegram.org/bot$Telegram_Api_code/sendMessage -d chat_id=$chat_id -d text="
    
    New DerpFest for Nokia 7 Plus build started 
    
    $(date)
    
    👤 By: Raghu Varma
    build's progress at $jenkinsurl"    
    export SELINUX_IGNORE_NEVERALLOWS=true
    . build/envsetup.sh && lunch derp_Onyx-userdebug && make target-files-package otatools
    romname=$(cat $path/derp/out/target/product/Onyx/system/etc/prop.default | grep ro.aosip.version | cut -d "=" -f 2)
    ./build/tools/releasetools/sign_target_files_apks -o -d $path/keys $path/derp/out/target/product/Onyx/obj/PACKAGING/target_files_intermediates/*-target_files-*.zip $path/derp/out/target/product/Onyx/signed-target-files.zip
    ./build/tools/releasetools/ota_from_target_files -k $path/keys/releasekey $path/derp/out/target/product/Onyx/signed-target-files.zip $path/derp/out/target/product/Onyx/DerpFest-$romname.zip
    cd out/target/product/Onyx
    rm -r **.json
    wget https://github.com/RaghuVarma331/scripts/raw/master/Json_generator/b2n_derp.sh
    chmod a+x b2n_derp.sh
    ./b2n_derp.sh
    zipname=$(echo DerpFest**.zip)
    cat $zipname.json > $path/json/Onyx/derp.json      
    sshpass -p $password rsync -avP -e ssh DerpFest**.zip     raghuvarma331@frs.sourceforge.net:/home/frs/project/b2n-sprout/DerpFest
    cd 
    cd $path
    python telegram.py -t $Telegram_Api_code -c $chat_id  -P derp.jpg -C "
    *
    New DerpFest Build is up 
    
    $(date)*
     
    ⬇️ [Download ROM](https://forum.xda-developers.com/nokia-7-plus/development/rom-aosip-derpfest-t4084459)
    ⬇️ [Download Vendor](https://forum.xda-developers.com/nokia-7-plus/development/vendor-b2n-b2nsprout-treble-gsi-vendor-t4040207)
    💬 [Device Changelog](https://raw.githubusercontent.com/RaghuVarma331/changelogs/master/nokia.txt)
    💬 [Installation procedure](https://github.com/RaghuVarma331/changelogs/raw/master/crossdevelopment/abcrins.txt)
    📱Device: *Nokia 7 Plus*
    ⚡Build Version: *Ten*
    ⚡Android Version: *10.0.0*
    ⚡Security Patch : *$securitypatch*
    👤 By: *Raghu Varma*
    #b2n #nokia #derp #update
    Follow: @Nokia7plusOfficial ✅"        
    cd json
    git add .
    git commit -m "Onyx: DerpFest 10.0 build $(date)"
    git push -u -f origin master
    cd ..     
    cd derp
    rm -r device/nokia
    rm -r out/target/product/**
    git clone https://github.com/RaghuVarma331/android_device_nokia_Crystal.git -b ten device/nokia/Crystal 
    cd packages/apps/Os_Updates/src/org/pixelexperience/ota/misc
    rm -r Constants.java
    wget https://github.com/RaghuVarma331/Json-configs/raw/master/Crystal/DerpFest/Constants.java
    cd
    cd $path/derp
    curl -s -X POST https://api.telegram.org/bot$Telegram_Api_code/sendMessage -d chat_id=$chat_id -d text="
    
    New DerpFest for Nokia 7.1 build started 
    
    $(date)
    
    👤 By: Raghu Varma
    build's progress at $jenkinsurl"    
    export SELINUX_IGNORE_NEVERALLOWS=true
    . build/envsetup.sh && lunch derp_Crystal-userdebug && make target-files-package otatools
    romname=$(cat $path/derp/out/target/product/Crystal/system/etc/prop.default | grep ro.aosip.version | cut -d "=" -f 2)
    ./build/tools/releasetools/sign_target_files_apks -o -d $path/keys $path/derp/out/target/product/Crystal/obj/PACKAGING/target_files_intermediates/*-target_files-*.zip $path/derp/out/target/product/Crystal/signed-target-files.zip
    ./build/tools/releasetools/ota_from_target_files -k $path/keys/releasekey $path/derp/out/target/product/Crystal/signed-target-files.zip $path/derp/out/target/product/Crystal/DerpFest-$romname.zip
    cd out/target/product/Crystal
    rm -r **.json
    wget https://github.com/RaghuVarma331/scripts/raw/master/Json_generator/ctl_derp.sh
    chmod a+x ctl_derp.sh
    ./ctl_derp.sh
    zipname=$(echo DerpFest**.zip)
    cat $zipname.json > $path/json/Crystal/derp.json     
    sshpass -p $password rsync -avP -e ssh DerpFest**.zip     raghuvarma331@frs.sourceforge.net:/home/frs/project/ctl-sprout/DerpFest
    cd 
    cd $path
    python telegram.py -t $Telegram_Api_code -c $chat_id  -P derp.jpg -C "
    *
    New DerpFest Build is up 
    
    $(date)*
     
    ⬇️ [Download ROM](https://forum.xda-developers.com/nokia-7-1/development/rom-aosip-derpfest-t4084451)
    ⬇️ [Download Vendor](https://forum.xda-developers.com/nokia-7-1/development/vendor-ctl-ctlsprout-treble-gsi-vendor-t4040211)
    💬 [Device Changelog](https://raw.githubusercontent.com/RaghuVarma331/changelogs/master/nokia.txt)
    💬 [Installation procedure](https://github.com/RaghuVarma331/changelogs/raw/master/crossdevelopment/abcrins.txt)
    📱Device: *Nokia 7.1*
    ⚡Build Version: *Ten*
    ⚡Android Version: *10.0.0*
    ⚡Security Patch : *$securitypatch*
    👤 By: *Raghu Varma*
    #ctl #nokia #derp #update
    Follow: @nokia7161 ✅"     
    cd json
    git add .
    git commit -m "Crystal: DerpFest 10.0 build $(date)"
    git push -u -f origin master
    cd ..     
    cd derp
    rm -r device/nokia
    rm -r out/target/product/**
    git clone https://github.com/RaghuVarma331/android_device_nokia_Plate2.git -b ten device/nokia/Plate2
    cd packages/apps/Os_Updates/src/org/pixelexperience/ota/misc
    rm -r Constants.java
    wget https://github.com/RaghuVarma331/Json-configs/raw/master/Plate2/DerpFest/Constants.java
    cd
    cd $path/derp
    curl -s -X POST https://api.telegram.org/bot$Telegram_Api_code/sendMessage -d chat_id=$chat_id -d text="
    
    New DerpFest for Nokia 6.1 build started 
    
    $(date)
    
    👤 By: Raghu Varma
    build's progress at $jenkinsurl"     
    export SELINUX_IGNORE_NEVERALLOWS=true
    . build/envsetup.sh && lunch derp_Plate2-userdebug && make target-files-package otatools
    romname=$(cat $path/derp/out/target/product/Plate2/system/etc/prop.default | grep ro.aosip.version | cut -d "=" -f 2)
    ./build/tools/releasetools/sign_target_files_apks -o -d $path/keys $path/derp/out/target/product/Plate2/obj/PACKAGING/target_files_intermediates/*-target_files-*.zip $path/derp/out/target/product/Plate2/signed-target-files.zip
    ./build/tools/releasetools/ota_from_target_files -k $path/keys/releasekey $path/derp/out/target/product/Plate2/signed-target-files.zip $path/derp/out/target/product/Plate2/DerpFest-$romname.zip

    cd out/target/product/Plate2
    rm -r **.json
    wget https://github.com/RaghuVarma331/scripts/raw/master/Json_generator/pl2_derp.sh
    chmod a+x pl2_derp.sh
    ./pl2_derp.sh
    zipname=$(echo DerpFest**.zip)
    cat $zipname.json > $path/json/Plate2/derp.json     
    sshpass -p $password rsync -avP -e ssh DerpFest**.zip     raghuvarma331@frs.sourceforge.net:/home/frs/project/pl2-sprout/DerpFest
    cd 
    cd $path
    python telegram.py -t $Telegram_Api_code -c $chat_id  -P derp.jpg -C "
    *
    New DerpFest Build is up 
    
    $(date)*
     
    ⬇️ [Download ROM](https://forum.xda-developers.com/nokia-6-2018/development/rom-aosip-derpfest-t4084463)
    ⬇️ [Download Vendor](https://forum.xda-developers.com/nokia-6-2018/development/vendor-pl2-pl2sprout-treble-gsi-vendor-t4040213)
    💬 [Device Changelog](https://raw.githubusercontent.com/RaghuVarma331/changelogs/master/nokia.txt)
    💬 [Installation procedure](https://github.com/RaghuVarma331/changelogs/raw/master/crossdevelopment/abcrins.txt)
    📱Device: *Nokia 6.1*
    ⚡Build Version: *Ten*
    ⚡Android Version: *10.0.0*
    ⚡Security Patch : *$securitypatch*
    👤 By: *Raghu Varma*
    #pl2 #nokia #derp #update
    Follow: @nokia7161 ✅"     
    cd json
    git add .
    git commit -m "Plate2: DerpFest 10.0 build $(date)"
    git push -u -f origin master
    cd 
    cd $path
    cd derp
    rm -r device/nokia
    rm -r out/target/product/**
    git clone https://github.com/RaghuVarma331/android_device_nokia_Daredevil.git -b ten device/nokia/Daredevil
    cd packages/apps/Os_Updates/src/org/pixelexperience/ota/misc
    rm -r Constants.java
    wget https://github.com/RaghuVarma331/Json-configs/raw/master/Daredevil/DerpFest/Constants.java
    cd
    cd $path/derp
    cd vendor/aosip/build/tasks
    rm -r kernel.mk
    wget https://github.com/RaghuVarma331/vendor_custom/raw/ten-los/build/tasks/kernel.mk
    cd
    cd $path/derp    
    curl -s -X POST https://api.telegram.org/bot$Telegram_Api_code/sendMessage -d chat_id=$chat_id -d text="
    
    New DerpFest for Nokia 7.2 build started 
    
    $(date)
    
    👤 By: Raghu Varma
    build's progress at $jenkinsurl"      
    export SELINUX_IGNORE_NEVERALLOWS=true
    . build/envsetup.sh && lunch derp_Daredevil-userdebug && make target-files-package otatools
    romname=$(cat $path/derp/out/target/product/Daredevil/system/etc/prop.default | grep ro.aosip.version | cut -d "=" -f 2)
    ./build/tools/releasetools/sign_target_files_apks -o -d $path/keys $path/derp/out/target/product/Daredevil/obj/PACKAGING/target_files_intermediates/*-target_files-*.zip $path/derp/out/target/product/Daredevil/signed-target-files.zip
    ./build/tools/releasetools/ota_from_target_files -k $path/keys/releasekey $path/derp/out/target/product/Daredevil/signed-target-files.zip $path/derp/out/target/product/Daredevil/DerpFest-$romname.zip
    cd out/target/product/Daredevil
    rm -r **.json
    wget https://github.com/RaghuVarma331/scripts/raw/master/Json_generator/ddv_derp.sh
    chmod a+x ddv_derp.sh
    ./ddv_derp.sh
    zipname=$(echo DerpFest**.zip)
    cat $zipname.json > $path/json/Daredevil/derp.json     
    sshpass -p $password rsync -avP -e ssh DerpFest**.zip     raghuvarma331@frs.sourceforge.net:/home/frs/project/ddv-sprout/DerpFest
    cd 
    cd $path
    python telegram.py -t $Telegram_Api_code -c $chat_id  -P derp.jpg -C "
    *
    New DerpFest Build is up 
    
    $(date)*
     
    ⬇️ [Download ROM](https://forum.xda-developers.com/nokia-7-2/development/rom-aosip-derpfest-t4084471)
    ⬇️ [Download Vendor](https://forum.xda-developers.com/nokia-7-2/development/vendor-ddv-ddvsprout-treble-gsi-vendor-t4083095)
    💬 [Device Changelog](https://raw.githubusercontent.com/RaghuVarma331/changelogs/master/nokia.txt)
    💬 [Installation procedure](https://github.com/RaghuVarma331/changelogs/raw/master/crossdevelopment/abcrins.txt)
    📱Device: *Nokia 7.2*
    ⚡Build Version: *Ten*
    ⚡Android Version: *10.0.0*
    ⚡Security Patch : *$securitypatch*
    👤 By: *Raghu Varma*
    #ddv #nokia #derp #update
    Follow: @Nokia7262 ✅"     
    cd json
    git add .
    git commit -m "Daredevil: DerpFest 10.0 build $(date)"
    git push -u -f origin master
    cd 
    cd $path
    rm -r derp
}

BLACKCAPS-SOURCE()
{   
    wget https://github.com/RaghuVarma331/custom_roms_banners/raw/master/kiwis.jpg
    wget  https://github.com/RaghuVarma331/scripts/raw/master/pythonscripts/telegram.py
    mkdir Black_Caps-Edition
    git clone https://github.com/RaghuVarma331/aarch64-linux-android-4.9.git -b master aarch64-linux-android-4.9
    git clone https://github.com/RaghuVarma331/android_kernel_nokia_sdm660.git -b ten-gcc --depth=1 drg
    cd drg
    export ARCH=arm64
    export CROSS_COMPILE=$path/aarch64-linux-android-4.9/bin/aarch64-linux-android-
    mkdir output
    make -C $(pwd) O=output SAT-perf_defconfig
    make -j32 -C $(pwd) O=output
    cp -r output/arch/arm64/boot/Image.gz-dtb $path/drg/DRG_sprout
    cd DRG_sprout
    zip -r Black_Caps-Edition-10.0-GCC-FIH-SDM660-2018-$(date +"%Y%m%d").zip META-INF patch tools Image.gz-dtb anykernel.sh
    cp -r Black_Caps-Edition-10.0-GCC-FIH-SDM660-2018-$(date +"%Y%m%d").zip $path/Black_Caps-Edition
    cd
    cd $path
    rm -r drg
    cd Black_Caps-Edition
    echo Sending build to sourceforge..
    sshpass -p $password rsync -avP -e ssh Black_Caps**.zip raghuvarma331@frs.sourceforge.net:/home/frs/project/drg-sprout/Black_Caps-Edition
    cd ..
    python telegram.py -t $Telegram_Api_code -c $chat_id  -P kiwis.jpg -C "
    *
    New Android 10
    Black_Caps-Edition 
    Build is up 
    
    $(date)*
    
    ⬇️ [Download](https://forum.xda-developers.com/nokia-6-1-plus/development/kernel-kiwis-kernel-9-0-0-nokia-6-1-t3963473)
    📱Device: *Nokia 6.1 Plus*
    ⚡Build Version: *$tag*
    ⚡Android Version: *10.0.0*
    👤 By: *Raghu Varma*
    #drg #nokia #kernel #update
    Follow:  @Nokia6plusofficial ✅"   
    
}    


TOOLS_SETUP() 
{
        sudo apt-get update 
        echo -ne '\n' | sudo apt-get upgrade
        echo -ne '\n' | sudo apt-get install git ccache schedtool lzop bison gperf build-essential zip curl zlib1g-dev g++-multilib python-networkx libxml2-utils bzip2 libbz2-dev libghc-bzlib-dev squashfs-tools pngcrush liblz4-tool optipng libc6-dev-i386 gcc-multilib libssl-dev gnupg flex lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev xsltproc unzip python-pip python-dev libffi-dev libxml2-dev libxslt1-dev libjpeg8-dev openjdk-8-jdk imagemagick device-tree-compiler mailutils-mh expect python3-requests python-requests android-tools-fsutils sshpass
        sudo swapon --show
        sudo fallocate -l 20G /swapfile
        ls -lh /swapfile
        sudo chmod 600 /swapfile
        sudo mkswap /swapfile
        sudo swapon /swapfile
        sudo swapon --show
        sudo cp /etc/fstab /etc/fstab.bak
        echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
	git config --global user.email "raghuvarma331@gmail.com"
	git config --global user.name "RaghuVarma331"
	mkdir -p ~/.ssh  &&  echo "Host *" > ~/.ssh/config && echo " StrictHostKeyChecking no" >> ~/.ssh/config
	echo "# Allow Jenkins" >> /etc/sudoers && echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
}

REPO()
{
       mkdir bin
       PATH=$path/bin:$PATH
       curl https://storage.googleapis.com/git-repo-downloads/repo > $path/bin/repo
       chmod a+x $path/bin/repo
}

		
# Main Menu
clear
echo "------------------------------------------------"
echo "A simple remote script to compile custom Stuff"
echo "Coded By Raghu Varma.G "
echo "------------------------------------------------"
PS3='Please select your option (1-6): '
menuvar=("BasicSetup" "pe" "lineageos" "derp" "Black_Caps-Edition" "all_roms" "Exit")
select menuvar in "${menuvar[@]}"
do
    case $menuvar in
        "BasicSetup")
            clear
            echo "----------------------------------------------"
            echo "Started Settingup Basic Stuff For Linux..."
            echo "Please be patient..."
            # Tools Setup
            echo "----------------------------------------------"
            echo "Setting Up Tools & Stuff..."
            echo " "
            TOOLS_SETUP
	    echo " "	    
            echo "----------------------------------------------"
            echo "Settingup Basic Stuff For Linux finished."
            echo " "
            echo "----------------------------------------------"
            echo "Press any key for end the script."
            echo "----------------------------------------------"
            read -n1 -r key
            break
            ;; 
        "Black_Caps-Edition")
            clear
            echo "----------------------------------------------"
            echo "Started Building Black_Caps-Edition For Nokia 6.1 Plus  ."
            echo "Please be patient..."
            # Black_Caps-Edition
            echo "----------------------------------------------"
            echo "Setting Up Tools & Stuff..."
            echo " "
            TOOLS_SETUP
	    echo " "	    
            echo "----------------------------------------------"
            echo "Setting up Black_Caps-Edition source..."
            echo " "
            BLACKCAPS-SOURCE
	    echo " "    
            echo "----------------------------------------------"
            echo "Black_Caps-Edition Build successfully completed."
            echo " "
            echo "----------------------------------------------"
            echo "Press any key for end the script."
            echo "----------------------------------------------"
            read -n1 -r key
            break
            ;;			    
        "pe")
            clear
            echo "----------------------------------------------"
            echo "Started Building Pixel-Experience for Nokia 6.1 Plus , 7 Plus & 6.1  ."
            echo "Please be patient..."
            # pe
            echo "----------------------------------------------"
            echo "Repo Setup..."
            echo " "
            REPO
	    echo " " 	    
            echo "----------------------------------------------"
            echo "Setting Up Tools & Stuff..."
            echo " "
            TOOLS_SETUP
	    echo " "	    
            echo "----------------------------------------------"
            echo "Setting up pe source..."
            echo " "
            PE-SOURCE
	    echo " "	 	    
            echo "----------------------------------------------"
            echo "Build successfully completed."
            echo " "
            echo "----------------------------------------------"
            echo "Press any key for end the script."
            echo "----------------------------------------------"
            read -n1 -r key
            break
            ;;	
        "lineageos")
            clear
            echo "----------------------------------------------"
            echo "Started Building LineageOS 17.1 for Nokia 6.1 Plus , 7 Plus  ."
            echo "Please be patient..."
            # lineageos
            echo "----------------------------------------------"
            echo "Repo Setup..."
            echo " "
            REPO
	    echo " " 	    
            echo "----------------------------------------------"
            echo "Setting Up Tools & Stuff..."
            echo " "
            TOOLS_SETUP
	    echo " "	    
            echo "----------------------------------------------"
            echo "Setting up los source..."
            echo " "
            LINEAGE-SOURCE
	    echo " "	 	    
            echo "----------------------------------------------"
            echo "Build successfully completed."
            echo " "
            echo "----------------------------------------------"
            echo "Press any key for end the script."
            echo "----------------------------------------------"
            read -n1 -r key
            break
            ;;
        "derp")
            clear
            echo "----------------------------------------------"
            echo "Started Building DerpFest for Nokia 6.1 Plus , 7 Plus  ."
            echo "Please be patient..."
            # derp
            echo "----------------------------------------------"
            echo "Repo Setup..."
            echo " "
            REPO
	    echo " " 	    
            echo "----------------------------------------------"
            echo "Setting Up Tools & Stuff..."
            echo " "
            TOOLS_SETUP
	    echo " "	    
            echo "----------------------------------------------"
            echo "Setting up DerpFest source..."
            echo " "
            DERP-SOURCE
	    echo " "	 	    
            echo "----------------------------------------------"
            echo "Build successfully completed."
            echo " "
            echo "----------------------------------------------"
            echo "Press any key for end the script."
            echo "----------------------------------------------"
            read -n1 -r key
            break
            ;;	   
        "all_roms")
            clear
            echo "----------------------------------------------"
            echo "Started Building LineageOS 17.1 , Pixel-EXP & Twrp for Nokia 6.1 Plus , 7 plus , 6.1 , 6.2 & 7.2 ."
            echo "Please be patient..."
            # all_roms
            echo "----------------------------------------------"
            echo "Repo Setup..."
            echo " "
            REPO
	    echo " " 	    
            echo "----------------------------------------------"
            echo "Setting Up Tools & Stuff..."
            echo " "
            TOOLS_SETUP
	    echo " "	    
            echo "----------------------------------------------"
            echo "Setting up los source..."
            echo " "
            LINEAGE-SOURCE
	    echo " "	 	    
            echo "----------------------------------------------"
            echo "Setting up pe source..."
            echo " "
            PE-SOURCE
	    echo " "
            echo "----------------------------------------------"
            echo "Setting up DerpFest source..."
            echo " "
            DERP-SOURCE
	    echo " "	    
            echo "----------------------------------------------"
            echo "Setting up Black_Caps-Edition source..."
            echo " "
            BLACKCAPS-SOURCE
	    echo " "		    
            echo "----------------------------------------------"
            echo "Build successfully completed."
            echo " "
            echo "----------------------------------------------"
            echo "Press any key for end the script."
            echo "----------------------------------------------"
            read -n1 -r key
            break
            ;;	    
        "Exit")
            break
            ;;
        *) echo Invalid option.;;
    esac
done              