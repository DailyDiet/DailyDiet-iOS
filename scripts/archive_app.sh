
#!/bin/bash

set -eo pipefail

xcodebuild -workspace ./DailyDiet.xcworkspace \
            -scheme DailyDiet.xcscheme
            -sdk iphoneos \
            -configuration AppStoreDistribution \
            -archivePath $PWD/build/DailyDiet.xcarchive \
            clean archive | xcpretty
