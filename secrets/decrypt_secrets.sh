#!/bin/sh


gpg --quiet --batch --yes --decrypt --passphrase="$IOS_KEYS" --output ./secrets/Certificates.p12 ./secrets/Certificates.p12.gpg


gpg --quiet --batch --yes --decrypt --passphrase="$IOS_KEYS" --output ./secrets/DailyDiet_Dist_profile.mobileprovision ./secrets/DailyDiet_Dist_profile.mobileprovision.gpg


mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles

cp ./secrets/DailyDiet_Dist_profile.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/DailyDiet_Dist_profile.mobileprovision


security create-keychain -p "1377" build.keychain
security import ./secrets/Certificates.p12 -t agg -k ~/Library/Keychains/build.keychain -P "1377" -A

security list-keychains -s ~/Library/Keychains/build.keychain
security default-keychain -s ~/Library/Keychains/build.keychain
security unlock-keychain -p "1377" ~/Library/Keychains/build.keychain

security set-key-partition-list -S apple-tool:,apple: -s -k "1377" ~/Library/Keychains/build.keychain
