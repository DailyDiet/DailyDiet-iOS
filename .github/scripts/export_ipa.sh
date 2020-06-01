#!/bin/bash

set -eo pipefail

xcodebuild -archivePath $PWD/build/DailyDiet.xcarchive \
            -exportOptionsPlist DailyDiet/DailyDiet/exportOptions.plist \
            -exportPath $PWD/build \
            -allowProvisioningUpdates \
            -exportArchive | xcpretty
