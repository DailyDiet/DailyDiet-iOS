// This file contains the fastlane.tools configuration
// You can find the documentation at https://docs.fastlane.tools
//
// For a list of all available actions, check out
//
//     https://docs.fastlane.tools/actions
//

import Foundation

class Fastfile: LaneFile {
	func betaLane() {
//    ENV["FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD"] = "wqkp-mxwf-eqtd-ysch"
	desc("Push a new beta build to TestFlight")
		buildApp(workspace: "DailyDiet.xcworkspace", scheme: "DailyDiet")
		uploadToTestflight(username: "aliireza12t@icloud.com")
	}
}
