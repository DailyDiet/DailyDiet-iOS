// This class is automatically included in FastlaneRunner during build

// This autogenerated file will be overwritten or replaced when running "fastlane generate_swift"
//
//  ** NOTE **
//  This file is provided by fastlane and WILL be overwritten in future updates
//  If you want to add extra functionality to this project, create a new file in a
//  new group so that it won't be marked for upgrade
//

import Foundation

lane :beta do
  build_app(scheme: "MyApp",
            workspace: "Example.xcworkspace",
            include_bitcode: false)
  upload_to_testflight
  increment_build_number(build_number: number_of_commits)
  increment_build_number(xcodeproj: "Example.xcodeproj")
end
