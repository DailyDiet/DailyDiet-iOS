#!/bin/sh


gpg --quiet --batch --yes --decrypt --passphrase="$IOS_KEYS" --output ./secrets/Certificates.p12 ./secrets/Certificates.p12.gpg


gpg --quiet --batch --yes --decrypt --passphrase="$IOS_KEYS" --output ./secrets/DailyDiet_Dist_profile.mobileprovision ./secrets/DailyDiet_Dist_profile.mobileprovision.gpg


mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles

cp ./.github/secrets/DailyDiet_Dist_profile.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/DailyDiet_Dist_profile.mobileprovision


security create-keychain -p "" build.keychain
security import ./secrets/Certificates.p12 -t agg -k ~/Library/Keychains/build.keychain -P "" -A

security list-keychains -s ~/Library/Keychains/build.keychain
security default-keychain -s ~/Library/Keychains/build.keychain
security unlock-keychain -p "" ~/Library/Keychains/build.keychain

security set-key-partition-list -S apple-tool:,apple: -s -k "" ~/Library/Keychains/build.keychain
