#!/bin/sh
#

gpg --quiet --batch --yes --decrypt --passphrase="$IOS_PROFILE_KEY" --output ./secrets/profile.mobileprovision ./secrets/Developer_Profile.mobileprovision.gpg
gpg --quiet --batch --yes --decrypt --passphrase="$IOS_PROFILE_KEY" --output ./secrets/Certificates.p12 ./secrets/Certificates.p12.gpg

mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles

cp ./secrets/profile.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/86ce4d81-fd7e-46b2-ae6a-3092b4af6cd7.mobileprovision


security create-keychain -p "" build3.keychain
security import ./secrets/Certificates.p12 -t agg -k ~/Library/Keychains/build3.keychain -P "" -A

security list-keychains -s ~/Library/Keychains/build3.keychain
security default-keychain -s ~/Library/Keychains/build3.keychain
security unlock-keychain -p "" ~/Library/Keychains/build3.keychain

security set-key-partition-list -S apple-tool:,apple: -s -k "1377Aliireza1377@" ~/Library/Keychains/build3.keychain
