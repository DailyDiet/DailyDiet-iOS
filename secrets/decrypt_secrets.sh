#!/bin/sh


gpg --quiet --batch --yes --decrypt --passphrase="$IOS_PROFILE_KEY" --output ./.github/secrets/profile.mobileprovision ./.github/secrets/profile.mobileprovision.gpg
gpg --quiet --batch --yes --decrypt --passphrase="$IOS_PROFILE_KEY" --output ./.github/secrets/Certificates.p12 ./.github/secrets/Certificates.p12.gpg

mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles

cp ./.github/secrets/profile.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/86ce4d81-fd7e-46b2-ae6a-3092b4af6cd7.mobileprovision


security create-keychain -p "$KEYCHAIN_PASS" build.keychain
security import ./.github/secrets/Certificates.p12 -t agg -k ~/Library/Keychains/build.keychain -P "$KEYCHAIN_PASS" -A

security list-keychains -s ~/Library/Keychains/build.keychain
security default-keychain -s ~/Library/Keychains/build.keychain
security unlock-keychain -p "$KEYCHAIN_PASS" ~/Library/Keychains/build.keychain

security set-key-partition-list -S apple-tool:,apple: -s -k "$KEYCHAIN_PASS" ~/Library/Keychains/build.keychain
