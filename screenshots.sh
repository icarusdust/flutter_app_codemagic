#!/bin/sh
#makes sure ios devices required to generate screenshots for AppStore deployment are booted

function shutdownSimulator() {
	if [ ! -f /tmp/runningDevices.txt ]; then
		flutter devices > /tmp/runningDevices.txt
	fi
	grep "$1" /tmp/runningDevices.txt && echo "shutting down $1" && xcrun simctl shutdown "$1"

}

#cleans screenshots folder
rm -rf screenshots

#makes sure no devices are booted initially to solve insufficient resources issue
echo "Shutting down any running simulators we need"
shutdownSimulator $IPAD_PRO_129_4TH_DEVICE_ID
shutdownSimulator $IPHONE_11_PRO_MAX_DEVICE_ID
shutdownSimulator $IPHONE_8_PLUS_DEVICE_ID
shutdownSimulator $IPAD_PRO_11_3RD_DEVICE_ID
#shutdownSimulator $IPAD_AIR_4TH_DEVICE_ID

#generates screenshots

#### New versions of xcode/ios sdk, do not have this emulator (it is in iOS 12.1 sdk)
#### 12.9 inch (2nd generation iPad Pro) screenshots, required if app runs on iPad
# xcrun simctl create "iPad Pro (12.9-inch) (2nd generation)" "com.apple.CoreSimulator.SimDeviceType.iPad-Pro--12-9-inch---2nd-generation-"

#echo "Cleaning the flutter directory"
#flutter clean

#### iPad Air (4th generation) screenshots, required if app runs on iPad, but no 12.9 inch iPad pro 2nd Gen
#echo "generate screenshots iPad Air 4th gen ($IPAD_AIR_4TH_DEVICE_ID)"
#xcrun simctl erase $IPAD_AIR_4TH_DEVICE_ID
#xcrun simctl boot $IPAD_AIR_4TH_DEVICE_ID
#AF693EA2-3CEE-406E-9FD3-2AEF7C7AE4E0
SCREENSHOTS_DEVICE=ipadAir flutter drive --target test_driver/screenshots.dart -d $IPAD_AIR_4TH_DEVICE_ID
#xcrun simctl shutdown $IPAD_AIR_4TH_DEVICE_ID

#### 11 inch (3rd generation iPad Pro) screenshots, required if app runs on iPad, but no 12.9 inch iPad pro 2nd Gen
echo "generate screenshots for 11 inch iPad Pro 3rd gen ($IPAD_PRO_11_3RD_DEVICE_ID)"
xcrun simctl erase $IPAD_PRO_11_3RD_DEVICE_ID
xcrun simctl boot $IPAD_PRO_11_3RD_DEVICE_ID
# 503ED4B8-9480-401C-99CC-F37B5E9DEDEE
SCREENSHOTS_DEVICE=ipadPro11 flutter drive --target test_driver/screenshots.dart -d $IPAD_PRO_129_4TH_DEVICE_ID
xcrun simctl shutdown $IPAD_PRO_11_3RD_DEVICE_ID

#### 12.9 inch (4th generation iPad Pro) screenshots, required if app runs on iPad
echo "generate screenshots for 12.9 iPad Pro 4th gen ($IPAD_PRO_129_4TH_DEVICE_ID)"
xcrun simctl erase $IPAD_PRO_129_4TH_DEVICE_ID
xcrun simctl boot $IPAD_PRO_129_4TH_DEVICE_ID
# D64740E4-9414-4D6E-824C-4CEEA6F85ABF
SCREENSHOTS_DEVICE=ipadPro129 flutter drive --target test_driver/screenshots.dart -d $IPAD_PRO_129_4TH_DEVICE_ID
xcrun simctl shutdown $IPAD_PRO_129_4TH_DEVICE_ID

#### 6.5" screenshots, required if app runs on iPhone
echo "generate screenshots for iPhone 11 Pro Max($IPHONE_11_PRO_MAX_DEVICE_ID)"
xcrun simctl erase $IPHONE_11_PRO_MAX_DEVICE_ID
xcrun simctl boot $IPHONE_11_PRO_MAX_DEVICE_ID
# 3F9C2301-6AD8-409F-B275-29316C7CAC55
SCREENSHOTS_DEVICE=iPhone11ProMax flutter drive --target test_driver/screenshots.dart -d $IPHONE_11_PRO_MAX_DEVICE_ID
xcrun simctl shutdown $IPHONE_11_PRO_MAX_DEVICE_ID

#### 5.5" screenshots, required if app runs on iPhone
echo "generate screenshots for iPhone 8 Plus ($IPHONE_8_PLUS_DEVICE_ID)"
xcrun simctl erase $IPHONE_8_PLUS_DEVICE_ID
xcrun simctl boot $IPHONE_8_PLUS_DEVICE_ID
# EFC4BF4B-75E7-4319-A2E7-D95F84BF0475
SCREENSHOTS_DEVICE=iPhone8Plus flutter drive --target test_driver/screenshots.dart -d $IPHONE_8_PLUS_DEVICE_ID
xcrun simctl shutdown $IPHONE_8_PLUS_DEVICE_ID

#### COPY TO ANDROID
echo "copy iPhone 8 plus screenshots to Android screenshots folder"
rm -rf ios/fastlane/metadata/android/en-US/images/phoneScreenshots/*
mkdir -p ios/fastlane/metadata/android/en-US/images/phoneScreenshots/
cp screenshots/en-US/iPhone8Plus*.png ios/fastlane/metadata/android/en-US/images/phoneScreenshots

